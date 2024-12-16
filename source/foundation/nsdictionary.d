/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSDictionary
*/
module foundation.nsdictionary;
import foundation;
import objc;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

/**
    NSDictionary
*/
extern(Objective-C)
extern class NSDictionary(Key, Value) : NSObject, NSCopying, NSFastEnumeration, NSMutableCopying, NSSecureCoding
if (isObjcClassInstance!Key && isObjcClassInstance!Value) {
@nogc nothrow:
public:

    /**
        Allocates a new NSDictionary
    */
    override static NSDictionary!(Key, Value) alloc() @selector("alloc");

    /**
        Returns an initialized NSDictionary object.
    */
    override NSDictionary!(Key, Value) init() @selector("init");

    /**
        A Boolean value that indicates whether or not the class 
        supports secure coding.
    */
    @property bool supportsSecureCoding();

    /**
        The number of entries in the dictionary.
    */
    @property NSUInteger count() const;

    /**
        A new array containing the dictionary’s keys, or an empty 
        array if the dictionary has no entries.
    */
    @property NSArray!Key keys() const;

    /**
        A new array containing the dictionary’s values, or an 
        empty array if the dictionary has no entries.
    */
    @property NSArray!Value values() const;

    /**
        Returns the value associated with a given key.
    */
    extern(D)
    final
    Value opIndex(Key index) {
        static if (is(Key : NSString))
            return self.send!Value("valueForKey:", index);
        else
            return self.send!Value("objectForKey:", index);
    }
    
    /**
        Encodes the receiver using a given archiver.
    */
    void encodeWithCoder(NSCoder coder) @selector("encodeWithCoder:");

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id mutableCopyWithZone(NSZone* zone) @selector("mutableCopyWithZone:");

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id copyWithZone(NSZone* zone) @selector("copyWithZone:");
    
    /**
        Returns by reference a C array of objects over which the sender should iterate, 
        and as the return value the number of objects in the array.
    */
    NSUInteger countByEnumeratingWithState(NSFastEnumerationState* state, id* stackbuf, NSUInteger len) @selector("countByEnumeratingWithState:objects:count:");

}

/**
    NSMutableDictionary
*/
extern(Objective-C)
extern class NSMutableDictionary(Key, Value) : NSDictionary!(Key, Value) 
if (is(Key : NSCopying)) {
@nogc nothrow:
public:

    /**
        Allocates a new NSDictionary
    */
    override static NSMutableDictionary!(Key, Value) alloc() @selector("alloc");

    /**
        Returns an initialized NSDictionary object.
    */
    override NSMutableDictionary!(Key, Value) init() @selector("init");

    /**
        Adds a given key-value pair to the dictionary.
    */
    void opIndexAssign(Value value, Key key) {
        static if (is(Key : NSString))
            this.message!void("setValue:forKey:", value, key);
        else
            this.message!void("setObject:forKey:", value, key);
    }
}