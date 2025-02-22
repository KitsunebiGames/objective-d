/**
    Foundation Core Types

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.core;

/**
    A structure used to describe a portion of a series, such as characters in a string or objects in an array.
*/
struct NSRange {
nothrow @nogc:

    /**
        The index of the first member of the range.
    */
    NSUInteger location;

    /**
        The number of items in the range.
    */
    NSUInteger length;

    /**
        Returns the sum of the location and length of the range.
    */
    @property max() => location+length;

    /**
        Returns a Boolean value that indicates whether two given ranges are equal.
    */
    bool opEquals(const(NSRange) other) const {
        return this.location == other.location && this.length == other.length;
    }

    /**
        Returns a Boolean value that indicates whether a specified position is in a given range.
    */
    bool inRange(NSUInteger location) => this.location >= location && location < this.max();

    /**
        Returns the intersection of the specified ranges.

        Returns:  
            A range describing the intersection of range1 and range2—that is, 
            a range containing the indices that exist in both ranges.

        If the returned range’s length field is 0, then the two ranges don’t intersect, 
        and the value of the location field is undefined.
    */
    NSRange intersect(NSRange other) {
        NSUInteger loc = NSMax(this.location, other.location);
        return NSRange(
            location: loc,
            length: NSMin(this.max, other.max)-loc,
        );
    }

    /**
        Returns the union of the specified ranges.
    */
    NSRange unionize(NSRange other) {
        NSUInteger loc = NSMin(location, other.location);
        return NSRange(
            location: loc,
            length: NSMin(this.max, other.max)-loc
        );
    }
}

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
