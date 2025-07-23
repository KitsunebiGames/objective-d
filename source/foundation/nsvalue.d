/**
    NSValue

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.nsvalue;
import foundation;
import objc;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

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
        Creates a NSNumber instance with a bool value.
    */
    static NSNumber create(bool value) @selector("numberWithBool:");

    /**
        Creates a NSNumber instance with a double value.
    */
    static NSNumber create(double value) @selector("numberWithDouble:");

    /**
        Creates a NSNumber instance with a float value.
    */
    static NSNumber create(float value) @selector("numberWithFloat:");

    /**
        Creates a NSNumber instance with a byte value.
    */
    static NSNumber create(byte value) @selector("numberWithChar:");

    /**
        Creates a NSNumber instance with a short value.
    */
    static NSNumber create(short value) @selector("numberWithShort:");

    /**
        Creates a NSNumber instance with a int value.
    */
    static NSNumber create(int value) @selector("numberWithInt:");

    /**
        Creates a NSNumber instance with a long value.
    */
    static NSNumber create(long value) @selector("numberWithLongLong:");

    /**
        Creates a NSNumber instance with a ubyte value.
    */
    static NSNumber create(ubyte value) @selector("numberWithUnsignedChar:");

    /**
        Creates a NSNumber instance with a ushort value.
    */
    static NSNumber create(ushort value) @selector("numberWithUnsignedShort:");

    /**
        Creates a NSNumber instance with a uint value.
    */
    static NSNumber create(uint value) @selector("numberWithUnsignedInt:");

    /**
        Creates a NSNumber instance with a ulong value.
    */
    static NSNumber create(ulong value) @selector("numberWithUnsignedLongLong:");

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
    NSNumber initWith(bool value) @selector("initWithBool:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(char value) @selector("initWithChar:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(double value) @selector("initWithDouble:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(float value) @selector("initWithFloat:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(float value) @selector("initWithFloat:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(int value) @selector("initWithInt:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(short value) @selector("initWithShort:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(NSInteger value) @selector("initWithInteger:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(ubyte value) @selector("initWithUnsignedChar:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(ushort value) @selector("initWithUnsignedShort:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(uint value) @selector("initWithUnsignedInt:");

    /**
        Creates and returns an NSNumber object containing a given value.
    */
    NSNumber initWith(NSUInteger value) @selector("initWithUnsignedInteger:");

    /**
        Gets whether this number is equal to another.
    */
    bool isEqual(NSNumber other) @selector("isEqualToNumber:");
}