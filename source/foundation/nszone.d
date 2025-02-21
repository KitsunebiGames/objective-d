/**
    NSZone

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.nszone;
import foundation;
import objc;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

/**
    A protocol that objects adopt to provide functional copies of themselves.
*/
extern(Objective-C)
extern interface NSMutableCopying {
@nogc nothrow:
public:

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id mutableCopyWithZone(NSZone* zone) @selector("mutableCopyWithZone:");
}

/**
    A protocol that objects adopt to provide functional copies of themselves.
*/
extern(Objective-C)
extern interface NSCopying {
@nogc nothrow:
public:

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id copyWithZone(NSZone* zone) @selector("copyWithZone:");
}

/**
    A type used to identify and manage memory zones.

    These are not used in modern development.
*/
struct NSZone;