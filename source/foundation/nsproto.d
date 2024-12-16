/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSObjectProtocol
*/
module foundation.nsproto;
import foundation;
import objc.basetypes;
import objc.rt;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

/**
    The base protocol all Objective-C protocols should follow.
*/
extern(Objective-C)
extern interface NSObject {
@nogc nothrow:
public:

    /**
        Returns the class object for the receiver’s class.
    */
    @property Class class_() @selector("class");

    /**
        Returns the class object for the receiver’s superclass.
    */
    @property Class superclass() @selector("superclass");

    /**
        Returns a Boolean value that indicates whether the receiver 
        is an instance of given class or an instance of any class that 
        inherits from that class.
    */
    bool isCompatibleWith(Class klass) @selector("isKindOfClass:");

    /**
        Returns a Boolean value that indicates whether the receiver 
        is an instance of a given class.
    */
    bool isClassOf(Class klass) @selector("isMemberOfClass:");

    /**
        Returns a Boolean value that indicates whether instances of 
        the receiver are capable of responding to a given selector.
    */
    bool respondsTo(SEL selector) @selector("instancesRespondToSelector:");

    /**
        Returns a Boolean value that indicates whether the target 
        conforms to a given protocol.
    */
    bool conformsTo(Protocol protocol) @selector("conformsToProtocol:");

    /**
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(inout(id) obj) inout @selector("isEqual:");

    /**
        Returns an integer that can be used as a table address in a hash table structure.
    */
    @property NSUInteger hash() @selector("hash");

    /**
        Returns the receiver.
    */
    @property id self() @selector("self");

    /**
        Returns the receiver.
    */
    @property T self(T)() => cast(T)this;

    /**
        A textual representation of the receiver.
    */
    @property NSString description() @selector("description");

    /**
        A textual representation of the receiver to use with a debugger.
    */
    @property NSString debugDescription() @selector("debugDescription");

    /**
        Returns a Boolean value that indicates whether the receiver 
        does not descend from NSObject.
    */
    bool isProxy() @selector("isProxy");

    /**
        Sends a specified message to the receiver and returns the 
        result of the message.
    */
    id perform(SEL selector) @selector("performSelector:");

    /**
        Sends a message to the receiver with an object as the argument.
    */
    id perform(SEL selector, id object1) @selector("performSelector:withObject:");

    /**
        Sends a message to the receiver with two objects as arguments.
    */
    id perform(SEL selector, id object1, id object2) @selector("performSelector:withObject:withObject:");

    /**
        Increments the receiver’s reference count.
    */
    void retain() @selector("retain");

    /**
        Decrements the receiver’s reference count.
    */
    void release() @selector("release");

    /**
        Decrements the receiver’s retain count at the end of the current autorelease pool block.
    */
    void autorelease() @selector("autorelease");

    /**
        Decrements the receiver’s reference count.
    */
    NSUInteger retainCount() @selector("retainCount");
}