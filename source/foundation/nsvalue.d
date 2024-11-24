/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSValue
*/
module foundation.nsvalue;
import foundation;
import objc;

import core.attribute : selector, optional;

/**
    A simple container for a single C or Objective-C data item.
*/
extern(Objective-C)
extern class NSValue : NSObject, NSCopying, NSSecureCoding {
@nogc nothrow:
public:

    /**
        A Boolean value that indicates whether or not the class 
        supports secure coding.
    */
    @property bool supportsSecureCoding();
    
    /**
        Encodes the receiver using a given archiver.
    */
    void encodeWithCoder(NSCoder coder) @selector("encodeWithCoder:");

    /**
        Allocates a new NSString
    */
    override static NSValue alloc() @selector("alloc");

    /**
        Returns an initialized NSString object.
    */
    override NSValue init() @selector("init");

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id copyWithZone(NSZone* zone) @selector("copyWithZone:");

    /**
        Returns the value as an untyped pointer.
    */
    @property void* pointerValue();
    alias ptr = pointerValue;
}

/**
    An object wrapper for primitive scalar numeric values.
*/
extern(Objective-C)
extern class NSNumber : NSValue {
@nogc nothrow:
public:

    /**
        Allocates a new NSString
    */
    override static NSNumber alloc() @selector("alloc");

    /**
        Returns an initialized NSString object.
    */
    override NSNumber init() @selector("init");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property bool boolValue() const @selector("boolValue");

    /**
        The number object's value expressed as a char.
    */
    @property byte byteValue() const @selector("charValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property double doubleValue() const @selector("doubleValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property float floatValue() const @selector("floatValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property int intValue() const @selector("intValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property short shortValue() const @selector("shortValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property NSInteger integerValue() const @selector("integerValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property long longLongValue() const @selector("longLongValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property ubyte unsignedCharValue() const @selector("unsignedCharValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property ushort unsignedShortValue() const @selector("unsignedShortValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property uint unsignedIntValue() const @selector("unsignedIntValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property NSUInteger unsignedIntegerValue() const @selector("unsignedIntegerValue");

    /**
        The number object's value expressed as a Boolean value.
    */
    @property ulong unsignedLongLongValue() const @selector("unsignedLongLongValue");

    /**
        The number object's value expressed as a human-readable string.
    */
    @property NSString stringValue() const @selector("stringValue");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(bool value) @selector("initWithBool:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(char value) @selector("initWithChar:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(double value) @selector("initWithDouble:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(float value) @selector("initWithFloat:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(float value) @selector("initWithFloat:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(int value) @selector("initWithInt:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(short value) @selector("initWithShort:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(NSInteger value) @selector("initWithInteger:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(ubyte value) @selector("initWithUnsignedChar:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(ushort value) @selector("initWithUnsignedShort:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(uint value) @selector("initWithUnsignedInt:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    this(NSUInteger value) @selector("initWithUnsignedInteger:");

    /**
        Gets whether this number is equal to another.
    */
    bool isEqual(NSNumber other) @selector("isEqualToNumber:");

    /**
        Implements equality comparison
    */
    extern(D)
    bool opEquals(T)(T other) if (is(T : NSNumber)) {
        return this.isEqual(other.self_);
    }
}