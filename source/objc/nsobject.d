/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSObject and NSObjectProtocol
*/
module objc.nsobject;
import objc.rt;
import core.attribute : selector, optional;

/**
    Unsigned Integer
*/
alias NSUInteger = size_t;

/**
    Integer
*/
alias NSInteger = ptrdiff_t;

/**
    Gets the name of an Objective-C compatible class.
*/
string classname(T)(T obj) if(is(T : NSObjectProtocol)) {
    import core.stdc.string : strlen;
    auto name = obj.self.name();
    return cast(string)name[0..strlen(name)];
}

extern(Objective-C) extern:

pragma(mangle, "NSObject")
interface NSObjectProtocol {
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

/**
    Base class of all Objective-C classes.
*/
class NSObject :  NSObjectProtocol {
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
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(inout(id) obj) inout @selector("isEqual:");

    /**
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(inout(NSObject) obj) inout @selector("isEqual:");

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
        Returns a new instance of the receiving class.
    */
    static NSObject alloc() @selector("alloc");

    /**
        Implemented by subclasses to initialize a new object (the receiver) 
        immediately after memory for it has been allocated.
    */
    NSObject init() @selector("init");

    /**
        Returns the object returned by copyWithZone: where the zone is nil.
    */
    id copy() @selector("copy");

    /**
        eturns the object returned by mutableCopyWithZone: where the zone is nil.
    */
    id mutableCopy() @selector("mutableCopy");

    /**
        Deallocates the memory occupied by the receiver.
    */
    void dealloc() @selector("dealloc");
    
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