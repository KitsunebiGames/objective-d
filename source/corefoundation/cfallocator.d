/*
    CoreFoundation Allocators

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfallocator;
import corefoundation.cfstring;
import corefoundation.core;

/**
    CFAllocator is an opaque type that allocates and deallocates memory for you. 
    You never have to allocate, reallocate, or deallocate memory directly for Core Foundation objects—and rarely should you. 
    You pass CFAllocator objects into functions that create objects; these functions have “Create” embedded in their names, 
    for example, CFStringCreateWithPascalString. The creation functions use the allocators to allocate memory for the objects they create. 
*/
alias CFAllocatorRef = CFSubType!("CFAllocator");

extern(C) @nogc nothrow:

/**
    A prototype for a function callback that allocates memory of a requested size.
*/
alias CFAllocatorAllocateCallBack = const(void)* function(CFIndex allocSize, CFOptionFlags hint, void* info);

/**
    A prototype for a function callback that provides a description of the specified data.
*/
alias CFAllocatorCopyDescriptionCallBack = CFStringRef function(const(void)* info);

/**
    A prototype for a function callback that deallocates a block of memory.
*/
alias CFAllocatorDeallocateCallBack = const(void)* function(void* ptr, void* info);

/**
    A prototype for a function callback that gives the size of memory likely to be allocated, given a certain request.
*/
alias CFAllocatorPreferredSizeCallBack = CFIndex function(CFIndex size, CFOptionFlags hint, void* info);

/**
    A prototype for a function callback that reallocates memory of a requested size for an existing block of memory.
*/
alias CFAllocatorReallocateCallBack = const(void)* function(void* ptr, CFIndex newsize, CFOptionFlags hint, void* info);

/**
    A prototype for a function callback that releases the given data.
*/
alias CFAllocatorReleaseCallBack = const(void)* function(const(void)* info);

/**
    A prototype for a function callback that retains the given data.
*/
alias CFAllocatorRetainCallBack = const(void)* function(const(void)* info);

/**
    A structure that defines the context or operating environment for an allocator (CFAllocator) object. 
    Every Core Foundation allocator object must have a context defined for it.
*/
struct CFAllocatorContext {

    /**
        Assign the version number of the allocator. 
        
        Currently the only valid value is 0. 
    */
    CFIndex				                version_;

    /**
        An untyped pointer to program-defined data. Allocate memory for this data and assign a pointer to it. 
        This data is often control information for the allocator. 
        
        You may assign [null].
    */
    void*				                info;

    /**
        A prototype for a function callback that retains the data pointed to by the info field. 
        In implementing this function, retain the data you have defined for the allocator context in this field. 
        (This might make sense only if the data is a Core Foundation object.) 
        
        You may set this function pointer to [null].
    */
    CFAllocatorRetainCallBack		    retain;

    /**
        A prototype for a function callback that releases the data pointed to by the info field. 
        In implementing this function, release (or free) the data you have defined for the allocator context. 
        
        You may set this function pointer to [null], but doing so may result in memory leaks. 
    */
    CFAllocatorReleaseCallBack		    release;

    /**
        A prototype for a function callback that provides a description of the data pointed to by the info field. 
        In implementing this function, return a reference to a CFString object that describes your allocator, 
        particularly some characteristics of your program-defined data. 
        
        You may set this function pointer to [null], in which case Core Foundation will provide a rudimentary description.
    */
    CFAllocatorCopyDescriptionCallBack	copyDescription;

    /**
        A prototype for a function callback that allocates memory of a requested size. 
        In implementing this function, allocate a block of memory of at least size bytes and return a pointer to the start of the block. 
        The hint argument is a bitfield that you should currently not use (that is, assign 0). 
        The size parameter should always be greater than 0. 
        If it is not, or if problems in allocation occur, return [null].
        
        You may set this function pointer to [null].
    */
    CFAllocatorAllocateCallBack		    allocate;

    /**
        A prototype for a function callback that reallocates memory of a requested size for an existing block of memory. 
        
        You may set this function pointer to [null], in which case the CFAllocatorReallocate(_:_:) function has no effect. 
    */
    CFAllocatorReallocateCallBack	    reallocate;

    /**
        A prototype for a function callback that deallocates a given block of memory. 
        In implementing this function, make the block of memory pointed to by ptr available for subsequent 
        reuse by the allocator but unavailable for continued use by the program. 
        The ptr parameter cannot be NULL and if the ptr parameter is not a block of memory that has been 
        previously allocated by the allocator, the results are undefined; abnormal program termination can occur. 

        You may set this function pointer to [null], in which case the CFAllocatorDeallocate(_:_:) function has no effect. 
    */
    CFAllocatorDeallocateCallBack	    deallocate;

    /**
        A prototype for a function callback that determines whether there is enough free memory to satisfy a request. 
        In implementing this function, return the actual size the allocator is likely to allocate given a request for a block of memory of size size.
        
        The hint argument is a bitfield that you should currently not use. 
    */
    CFAllocatorPreferredSizeCallBack	preferredSize;
}

/**
    Returns the type identifier for the CFAllocator opaque type.
*/
extern CFTypeID CFAllocatorGetTypeID();

/**
	CFAllocatorSetDefault() sets the allocator that is used in the current
	thread whenever NULL is specified as an allocator argument. This means
	that most, if not all allocations will go through this allocator. It
	also means that any allocator set as the default needs to be ready to
	deal with arbitrary memory allocation requests; in addition, the size
	and number of requests will change between releases.

	An allocator set as the default will never be released, even if later
	another allocator replaces it as the default. Not only is it impractical
	for it to be released (as there might be caches created under the covers
	that refer to the allocator), in general it's also safer and more
	efficient to keep it around.

	If you wish to use a custom allocator in a context, it's best to provide
	it as the argument to the various creation functions rather than setting
	it as the default. Setting the default allocator is not encouraged.

	If you do set an allocator as the default, either do it for all time in
	your app, or do it in a nested fashion (by restoring the previous allocator
	when you exit your context). The latter might be appropriate for plug-ins
	or libraries that wish to set the default allocator.
*/
extern void CFAllocatorSetDefault(CFAllocatorRef allocator);

/**
    Gets the default allocator
*/
extern CFAllocatorRef CFAllocatorGetDefault();

/**
    Creates an allocator object.
*/
extern CFAllocatorRef CFAllocatorCreate(CFAllocatorRef allocator, CFAllocatorContext *context);

/**
    Allocates memory using the specified allocator.
*/
extern void* CFAllocatorAllocate(CFAllocatorRef allocator, CFIndex size, CFOptionFlags hint);

/**
    Reallocates memory using the specified allocator.
*/
extern void* CFAllocatorReallocate(CFAllocatorRef allocator, void *ptr, CFIndex newsize, CFOptionFlags hint);

/**
    Deallocates a block of memory with a given allocator.
*/
extern void CFAllocatorDeallocate(CFAllocatorRef allocator, void *ptr);

/**
    Obtains the number of bytes likely to be allocated upon a specific request.
*/
extern CFIndex CFAllocatorGetPreferredSizeForSize(CFAllocatorRef allocator, CFIndex size, CFOptionFlags hint);

/**
    Obtains the context of the specified allocator or of the default allocator.
*/
extern void CFAllocatorGetContext(CFAllocatorRef allocator, CFAllocatorContext *context);

/**
    Returns the allocator used to allocate a Core Foundation object.

    Params:
        cfObject =  The object to get the allocator for.

    Returns:
        The allocator that owns the object.
*/
extern CFAllocatorRef CFGetAllocator(CFTypeRef cfObject);