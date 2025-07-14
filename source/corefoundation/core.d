/**
    CoreFoundation Core Types

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.core;
import numem.core.types;
public import objc.bridge : objd_bridge;

extern(C) @nogc nothrow:

/**
    A type for unique, constant integer values that identify particular Core Foundation opaque types.
*/
alias CFTypeID = size_t;

/**
    CFOptionFlags
*/
alias CFOptionFlags = size_t;

/**
    A type for hash codes returned by the CFHash function.
*/
alias CFHashCode = size_t;

/**
    Priority values used for kAXPriorityKey
*/
alias CFIndex = ptrdiff_t;

/**
    Type used to represent elapsed time in seconds.
*/
alias CFTimeInterval = double;

/**
    Type used to represent a specific point in time relative to the 
    absolute reference date of 1 Jan 2001 00:00:00 GMT.
*/
alias CFAbsoluteTime = CFTimeInterval;

/**
    Type to mean any instance of a property list type;
    currently, CFString, CFData, CFNumber, CFBoolean, CFDate,
    CFArray, and CFDictionary.
*/
alias CFPropertyListRef = CFSubType!("CFPropertyList");

/**
    Callback function that compares two values. 
    You provide a pointer to this callback in certain Core Foundation sorting functions.
*/
alias CFComparatorFunction = extern(C) CFComparisonResult function(const(void)* val1, const(void)* val2, void* context);

/**
    Result of a comparison.
*/
enum CFComparisonResult : CFIndex {
    lessThan = -1,
    equalTo = 0,
    greaterThan = 1
}

/**
    Constant used by some functions to indicate failed searches.
*/
enum CFIndex kCFNotFound = -1;

/**
    A structure representing a range of sequential items in a container, 
    such as characters in a buffer or elements in a collection.
*/
struct CFRange {
    /**
        An integer representing the number of items in the range.
    
        For type compatibility with the rest of the system, [CFIndex.max] is the maximum value you should use for length.
    */
    CFIndex length;

    /**
        An integer representing the starting location of the range.
    
        For type compatibility with the rest of the system, [CFIndex.max] is the maximum value you should use for location.
    */
    CFIndex location;
}

// Declaration of base types.
alias Boolean           = bool;
alias UInt8             = ubyte;
alias SInt8             = byte;
alias UInt16            = ushort;
alias SInt16            = short;
alias UInt32            = uint;
alias SInt32            = int;
alias UInt64            = ulong;
alias SInt64            = long;
alias Int               = ptrdiff_t;
alias UInt              = size_t;
alias UniChar           = wchar;
alias StringPtr         = const(char)*;
alias Str255            = const(char)[255];
alias ConstStr255Param  = const(char)*;
alias OSErr             = UInt16;
alias OSStatus          = UInt32;
alias UTF32Char         = dchar;
alias UTF16Char         = wchar;
alias UTF8Char          = char;
alias OSType            = uint;

extern(C) @nogc nothrow:

/**
    Returns the reference count of a Core Foundation object.

    Params:
        cfObject =  The object to get the retain count for.

    Returns:
        The retain count of the object.
*/
extern CFIndex CFGetRetainCount(CFTypeRef cfObject);

/**
    Retains a Core Foundation object.

    Params:
        cfObject =  The object to retain.
*/
extern void CFRetain(CFTypeRef cfObject);

/**
    Releases a Core Foundation object.

    Params:
        cfObject =  The object to release.
*/
extern void CFRelease(CFTypeRef cfObject);

/**
    Releases a Core Foundation object.

    Params:
        cfObject =  The object to autorelease.

    Returns:
        Returns the object to be autoreleased.
*/
extern CFTypeRef CFAutorelease(CFTypeRef cfObject);

/**
    Determines whether two Core Foundation objects are considered equal.

    Params:
        cfObject1 = First object to compare.
        cfObject2 = Second object to compare.
*/
extern bool CFEqual(CFTypeRef cfObject1, CFTypeRef cfObject2);

/**
    Gets a hash for the given CoreFoundation Object.

    Params:
        cfObject =  The object to get a hash for
    
    Returns:
        The hash of the object.
*/
extern CFHashCode CFHash(CFTypeRef cfObject);

/**
    Returns the unique identifier of an opaque type to which a 
    Core Foundation object belongs.

    Params:
        cfObject =  The object to get th type ID for.
    
    Returns:
        A type ID.
*/
extern CFTypeID CFGetTypeID(CFTypeRef cfObject);

/**
    Generic CoreFoundation reference, essentially equivalent to
    NSObject
*/
alias CFTypeRef = __CFType*;
struct __CFType; /// ditto

/**
    Defines a CFTypeRef subtype; said subtype can be cast down to
    CFTypeRef, but not back up.

    Params:
        name =  The name of the subtype, preventing subtypes being implicitly
                cast to each other.
*/
template CFSubType(string name, AllowedBridge...) {
    import objc.bridge : objd_bridge;

    @objd_bridge!(AllowedBridge)
    struct __CFSubType(string name) { alias self this; __CFType* self; }
    alias CFSubType = __CFSubType!name;
}
