/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Mach Ports bindings
*/
module mach.ports;
import objc.os;

extern(C) nothrow @nogc:

public import core.sys.darwin.mach.port;
public import core.sys.darwin.mach.kern_return;
public import core.sys.darwin.mach.semaphore;

/// IPC Space
struct ipc_space;
alias ipc_space_t = ipc_space*;

/**
    The local identity of a mach port.
*/
alias mach_port_name_t = natural_t;

/**
    The type of a mach port.
*/
alias mach_port_type_t = natural_t;

/**
    The rights of a mach port.
*/
enum mach_port_right_t : uint {
    send = 0,
    recieve = 1,
    sendOnce = 2,
    portSet = 3,
    deadName = 4
}

/**
    Structure used to pass information about port allocation requests.
    Must be padded to 64-bits total length.
*/
struct mach_port_qos_t {
    uint flags;
    natural_t len;
}

/**
    Exception reasons for a mach port
*/
enum mach_port_guard_exception_codes_t : ulong {
	kGUARD_EXC_DESTROY                      = 1,
	kGUARD_EXC_MOD_REFS                     = 2,
	kGUARD_EXC_INVALID_OPTIONS              = 3,
	kGUARD_EXC_SET_CONTEXT                  = 4,
	kGUARD_EXC_THREAD_SET_STATE             = 5,
	kGUARD_EXC_EXCEPTION_BEHAVIOR_ENFORCE   = 6,
	kGUARD_EXC_UNGUARDED                    = 1u << 3,
	kGUARD_EXC_INCORRECT_GUARD              = 1u << 4,
	kGUARD_EXC_IMMOVABLE                    = 1u << 5,
	kGUARD_EXC_STRICT_REPLY                 = 1u << 6,
	kGUARD_EXC_MSG_FILTERED                 = 1u << 7,
	/* start of [optionally] non-fatal guards */
	kGUARD_EXC_INVALID_RIGHT                = 1u << 8,
	kGUARD_EXC_INVALID_NAME                 = 1u << 9,
	kGUARD_EXC_INVALID_VALUE                = 1u << 10,
	kGUARD_EXC_INVALID_ARGUMENT             = 1u << 11,
	kGUARD_EXC_RIGHT_EXISTS                 = 1u << 12,
	kGUARD_EXC_KERN_NO_SPACE                = 1u << 13,
	kGUARD_EXC_KERN_FAILURE                 = 1u << 14,
	kGUARD_EXC_KERN_RESOURCE                = 1u << 15,
	kGUARD_EXC_SEND_INVALID_REPLY           = 1u << 16,
	kGUARD_EXC_SEND_INVALID_VOUCHER         = 1u << 17,
	kGUARD_EXC_SEND_INVALID_RIGHT           = 1u << 18,
	kGUARD_EXC_RCV_INVALID_NAME             = 1u << 19,
	/* start of always non-fatal guards */
	kGUARD_EXC_RCV_GUARDED_DESC             = 1u << 20, /* for development only */
	kGUARD_EXC_MOD_REFS_NON_FATAL           = 1u << 21,
	kGUARD_EXC_IMMOVABLE_NON_FATAL          = 1u << 22,
	kGUARD_EXC_REQUIRE_REPLY_PORT_SEMANTICS = 1u << 23,
}

/**
    Returns the set of port and port set names
    to which the target task has access, along with
    the type (set or port) for each name.
*/
extern kern_return_t mach_port_names(ipc_space_t task, mach_port_name_t* names, mach_port_type_t* types);

/**
    Returns the type (set or port) for the port name
    within the target task.  Also indicates whether
    there is a dead-name request for the name
*/
extern kern_return_t mach_port_type(ipc_space_t task, mach_port_name_t name, mach_port_type_t* type);

/**
    Allocates the specified kind of object, with the given name.
    The right must be one of
        MACH_PORT_RIGHT_RECEIVE
        MACH_PORT_RIGHT_PORT_SET
        MACH_PORT_RIGHT_DEAD_NAME
    New port sets are empty.  New ports don't have any
    send/send-once rights or queued messages.  The make-send
    count is zero and their queue limit is MACH_PORT_QLIMIT_DEFAULT.
    New sets, ports, and dead names have one user reference.
*/
extern kern_return_t mach_port_allocate_name(ipc_space_t task, mach_port_right_t right, mach_port_name_t name);

/**
    Allocates the specified kind of object.
    The right must be one of
        MACH_PORT_RIGHT_RECEIVE
        MACH_PORT_RIGHT_PORT_SET
        MACH_PORT_RIGHT_DEAD_NAME
    Like port_allocate_name, but the kernel picks a name.
    It can use any name not associated with a right.
*/
extern kern_return_t mach_port_allocate(ipc_space_t task, mach_port_right_t right, mach_port_name_t* name);

/**
    Destroys all rights associated with the name and makes it
    available for recycling immediately.  The name can be a
    port (possibly with multiple user refs), a port set, or
    a dead name (again, with multiple user refs).
*/
extern kern_return_t mach_port_allocate(ipc_space_t task, mach_port_name_t name);

/**
    Releases one send/send-once/dead-name user ref.
    Just like mach_port_mod_refs -1, but deduces the
    correct type of right.  This allows a user task
    to release a ref for a port without worrying
    about whether the port has died or not.
*/
extern kern_return_t mach_port_deallocate(ipc_space_t task, mach_port_name_t name);

/**
    A port set always has one user ref.
    A send-once right always has one user ref.
    A dead name always has one or more user refs.
    A send right always has one or more user refs.
    A receive right always has one user ref.
    The right must be one of
        MACH_PORT_RIGHT_RECEIVE
        MACH_PORT_RIGHT_PORT_SET
        MACH_PORT_RIGHT_DEAD_NAME
        MACH_PORT_RIGHT_SEND
        MACH_PORT_RIGHT_SEND_ONCE
*/
extern kern_return_t mach_port_get_refs(ipc_space_t task, mach_port_name_t name, mach_port_right_t right, uint* urefs);

/**
    The delta is a signed change to the task's
    user ref count for the right.  Only dead names
    and send rights can have a positive delta.
    The resulting user ref count can't be negative.
    If it is zero, the right is deallocated.
    If the name isn't a composite right, it becomes
    available for recycling.  The right must be one of
        MACH_PORT_RIGHT_RECEIVE
        MACH_PORT_RIGHT_PORT_SET
        MACH_PORT_RIGHT_DEAD_NAME
        MACH_PORT_RIGHT_SEND
        MACH_PORT_RIGHT_SEND_ONCE
*/
extern kern_return_t mach_port_mod_refs(ipc_space_t task, mach_port_name_t name, mach_port_right_t right, uint delta);
