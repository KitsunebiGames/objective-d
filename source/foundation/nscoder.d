/**
    NSCoder

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.nscoder;
import foundation;
import objc;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

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