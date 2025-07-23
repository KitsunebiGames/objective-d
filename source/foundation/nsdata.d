/**
    NSData

    Copyright: Copyright © 2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.nsdata;
import foundation;
import objc;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

/**
    Immutable Data Store
*/
extern(Objective-C)
extern class NSData : NSObject, NSCopying, NSMutableCopying, NSSecureCoding {
@nogc:

    /**
        Creates an NSData Instance
    */
    static NSData create(void* bytes, NSUInteger length) @selector("dataWithBytes:length:");

    /**
        A Boolean value that indicates whether or not the class 
        supports secure coding.
    */
    override
    @property bool supportsSecureCoding();

    /**
        Length of the data in bytes.
    */
    @property NSUInteger length();

    /**
        Returns a pointer to a contiguous region of memory managed by the receiver.

        If the regions of memory represented by the receiver are already contiguous, 
        it does so in O(1) time, otherwise it may take longer Using 
        $(D enumerateByteRangesUsingBlock) will be efficient for both contiguous 
        and discontiguous data.
    */
    @property const(void)* bytes();

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    override
    id mutableCopyWithZone(NSZone* zone) @selector("mutableCopyWithZone:");

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    override
    id copyWithZone(NSZone* zone) @selector("copyWithZone:");
    
    /**
        Encodes the receiver using a given archiver.
    */
    override
    void encodeWithCoder(NSCoder coder) @selector("encodeWithCoder:");
}

/**
    Mutable Data Store
*/
extern(Objective-C)
extern class NSMutableData : NSData {
@nogc:

    /**
        Returns a pointer to a contiguous region of memory managed by the receiver.

        If the regions of memory represented by the receiver are already contiguous, 
        it does so in O(1) time, otherwise it may take longer Using 
        $(D enumerateByteRangesUsingBlock) will be efficient for both contiguous 
        and discontiguous data.
    */
    @property void* mutableBytes();

    /**
        Length of the data in bytes.
    */
    @property void length(NSUInteger value);
}