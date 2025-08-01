/**
    CoreFoundation Numbers

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfnumber;
import corefoundation.cfallocator;
import corefoundation.core;
import foundation.nsvalue;

extern(C) @nogc nothrow:

/**
    CoreFoundation boxed boolean
*/
alias CFBooleanRef = CFSubType!("CFBoolean", NSNumber);

/**
    CoreFoundation wrapped "true" value.
*/
extern __gshared CFBooleanRef kCFBooleanTrue;

/**
    CoreFoundation wrapped "false" value.
*/
extern __gshared CFBooleanRef kCFBooleanFalse;

/**
    Gets the type identifier for CFBoolean

    Returns:
        The Type ID of CFBoolean
*/
extern CFTypeID CFBooleanGetTypeID();

/**
    Gets the boolean value stored in a CFBoolean

    Returns:
        The contents of the CFBoolean
*/
extern bool CFBooleanGetValue(CFBooleanRef boolean);

/**
    Subtypes for CFNumber
*/
alias CFNumberType = CFIndex;
enum : CFNumberType {

    /* Fixed-width types */
    kCFNumberSInt8Type = 1,
    kCFNumberSInt16Type = 2,
    kCFNumberSInt32Type = 3,
    kCFNumberSInt64Type = 4,
    kCFNumberFloat32Type = 5,
    kCFNumberFloat64Type = 6,	/* 64-bit IEEE 754 */

    /* Basic C types */
    kCFNumberCharType = 7,
    kCFNumberShortType = 8,
    kCFNumberIntType = 9,
    kCFNumberLongType = 10,
    kCFNumberLongLongType = 11,
    kCFNumberFloatType = 12,
    kCFNumberDoubleType = 13,

    /* Other */
    kCFNumberCFIndexType = 14,
    kCFNumberNSIntegerType = 15,
    kCFNumberCGFloatType = 16,
    kCFNumberMaxType = 16
}

/**
    CoreFoundation boxed numbers
*/
alias CFNumberRef = CFSubType!("CFNumber", NSNumber);

/**
    CoreFoundation wrapped +infinity value.
*/
extern __gshared CFNumberRef kCFNumberPositiveInfinity;

/**
    CoreFoundation wrapped -infinity value.
*/
extern __gshared CFNumberRef kCFNumberNegativeInfinity;

/**
    CoreFoundation wrapped NaN value.
*/
extern __gshared CFNumberRef kCFNumberNaN;

/**
    Gets the type identifier for CFNumber

    Returns:
        The Type ID of CFNumber
*/
extern CFTypeID CFNumberGetTypeID();

/**
	Creates a CFNumber with the given value. The type of number pointed
	to by the valuePtr is specified by type. 

    Params:
        allocator = The allocator to use or $(D null) to use the default.
        theType = The number subtype of the given value.
        valuePtr = Pointer to the value to copy into the CFNumber
    
    Returns:
        If type is a floating point type and the value represents one 
        of the infinities or NaN, the well-defined CFNumber for that 
        value is returned. If either of valuePtr or type is an invalid 
        value, the result is undefined.
*/
extern CFNumberRef CFNumberCreate(CFAllocatorRef allocator, CFNumberType theType, const(void)* valuePtr);

/**
    Gets the underlying type of the CFNumber.
    
    Params:
        number = The CFNumber
    
    Returns:
        The subtype of the CFNumber.
*/
extern CFNumberType CFNumberGetType(CFNumberRef number);

/**
    Gets the size of the number value stored, in bytes.
    
    Params:
        number = The CFNumber
    
    Returns:
        The size of the number value stored, in bytes.
*/
extern CFIndex CFNumberGetByteSize(CFNumberRef number);

/**
    Gets whether the CFNumber contains a floating point number.

    Params:
        number = The CFNumber
    
    Returns:
        $(D true) if the CFNumber contains float data,
        $(D false) otherwise.
*/
extern bool CFNumberIsFloatType(CFNumberRef number);

/**
    Gets the value of the CFNumber, converting if needed.

    Params:
        number = The CFNumber
        theType = The type of value to get, converting if neccesary.
        valuePtr = Where to store the data.
    
    Returns:
        $(D true) if the operation succeeded 
        without any loss of accuracy, $(D false) otherwise.
*/
extern bool CFNumberGetValue(CFNumberRef number, CFNumberType theType, void *valuePtr);

/**
	Compares the two CFNumber instances. 
    
    If conversion of the types of the values is needed, 
    the conversion and comparison follow human expectations 
    and not C's promotion and comparison rules.
    Negative zero compares less than positive zero.
	Positive infinity compares greater than everything except
	itself, to which it compares equal. Negative infinity compares
	less than everything except itself, to which it compares equal.
	Unlike standard practice, if both numbers are NaN, then they
	compare equal; if only one of the numbers is NaN, then the NaN
	compares greater than the other number if it is negative, and
	smaller than the other number if it is positive. (Note that in
	CFEqual() with two CFNumbers, if either or both of the numbers
	is NaN, true is returned.)

    Params:
        number = The first number
        otherNumber = The second number
        context = The comparison context.

    Returns:
        The result of the comparison.
*/
extern CFComparisonResult CFNumberCompare(CFNumberRef number, CFNumberRef otherNumber, void *context);
