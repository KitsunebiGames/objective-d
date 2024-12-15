/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSObject and NSObjectProtocol
*/
module foundation.nscoder;
import foundation;
import objc;

import core.attribute : selector, optional;

/**
    A protocol that enables an object to be encoded and 
    decoded for archiving and distribution.
*/
extern(Objective-C)
extern interface NSCoding {
@nogc nothrow:
public:
    
    /**
        Encodes the receiver using a given archiver.
    */
    void encodeWithCoder(NSCoder coder) @selector("encodeWithCoder:");
}

/**
    A protocol that enables encoding and decoding in a manner 
    that is robust against object substitution attacks.
*/
extern(Objective-C)
extern interface NSSecureCoding : NSCoding {
@nogc nothrow:
public:

    /**
        A Boolean value that indicates whether or not the class 
        supports secure coding.
    */
    @property bool supportsSecureCoding();
}

/**
    An abstract class that serves as the basis for objects that enable 
    archiving and distribution of other objects.
*/
extern(Objective-C)
extern class NSCoder : NSObject {
@nogc nothrow:
public:

}