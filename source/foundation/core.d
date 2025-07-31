/**
    Foundation Core Types

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.core;
public import objc.basetypes;

/**
    Type indicating a parameter is a pointer to an NSRange structure.
*/
alias NSRangePointer = NSRange*;

/**
    A value indicating that a requested item couldn’t be found or doesn’t exist.
*/
enum NSInteger NSNotFound = NSInteger.max; // @suppress(dscanner.style.phobos_naming_convention)

/**
    Unsigned Integer
*/
alias NSUInteger = size_t;

/**
    Integer
*/
alias NSInteger = ptrdiff_t;

/**
    A number of seconds.
*/
alias NSTimeInterval = double;

/**
    Returns the larger of the 2 given scalar values.
*/
T NSMax(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs > rhs ? lhs : rhs;
}

/**
    Returns the smaller of the 2 given scalar values.
*/
T NSMin(T)(T lhs, T rhs) if (__traits(isScalar, T)) {
    return lhs < rhs ? lhs : rhs;
}
