/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSArray
*/
module foundation.nsarray;
import foundation;
import objc;

import core.attribute : selector, optional;
import numem.core.exception;

private alias iter_func(T) = int delegate(T);
private alias iter_i_func(T) = int delegate(size_t, T);

private
int iter_func_t(T)(T item, scope iter_func!T dg) @nogc {
    return assumeNoThrowNoGC(dg, item);
}  

private
int iter_i_func_t(T)(size_t idx, T item, scope iter_i_func!T dg) @nogc {
    return assumeNoThrowNoGC(dg, idx, item);
}  

nothrow @nogc:
version(D_ObjectiveC):

/**
    A static ordered collection of objects.
*/
extern(Objective-C)
extern class NSArray(T) : NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration
if(isObjcClassInstance!T) {
private:
@nogc nothrow:
public:

    /**
        Creates and returns an empty array.
    */
    static NSArray!T create() @selector("array");

    /**
        Creates and returns an array containing the objects in another given array.
    */
    static NSArray!T create(ref NSArray!T array) @selector("arrayWithArray:");

    /**
        Creates and returns an array containing a given object.
    */
    static NSArray!T create(T object) @selector("arrayWithObject:");

    /**
        Creates and returns an array containing the objects in the argument list.
    */
    static NSArray!T create(T* objects, NSUInteger count) @selector("arrayWithObjects:count:");

    /**
        Allows creating NSArrays from a D slice.
    */
    extern(D)
    final // @suppress(dscanner.useless.final)
    static NSArray!T create(T[] objects) {
        return NSArray!T.create(objects.ptr, objects.length);
    }

    /**
        Allocates a new NSArray
    */
    override static NSArray!T alloc() @selector("alloc");

    /**
        Returns a NSArray object.
    */
    override NSArray!T init() @selector("init");

    /**
        Initializes a newly allocated array by placing in it the objects contained in a given array.
    */
    NSArray!T init(ref NSArray!T array) @selector("initWithArray:");

    /**
        Initializes a newly allocated array using anArray as the source of data objects for the array. 
    */
    NSArray!T init(ref NSArray!T array, bool copy) @selector("initWithArray:copyItems:");

    /**
        Creates and returns an array containing the objects in the argument list.
    */
    NSArray!T init(T firstObject, ...) @selector("initWithObjects:");

    /**
        Creates and returns an array containing the objects in the argument list.
    */
    NSArray!T init(T* objects, NSUInteger count) @selector("initWithObjects:count:");

    /**
        A Boolean value that indicates whether or not the class 
        supports secure coding.
    */
    @property bool supportsSecureCoding() @selector("supportsSecureCoding");

    /**
        The number of objects in the array.
    */
    @property NSUInteger count() const @selector("count");

    /**
        Gets the first element
    */
    @property T front() const @selector("firstObject");

    /**
        Gets the last element
    */
    @property T back() const @selector("lastObject");

    /**
        Returns a Boolean value that indicates whether a given object is present in the array.
    */
    bool contains(T obj) @selector("containsObject:");
    
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
        Returns the object located at the specified index.
    */
    T objectAtIndex(NSUInteger index) @selector("objectAtIndex:");

    /**
        Returns the lowest index whose corresponding array 
        value is equal to a given object.
    
        Returns -1 if not found.
    */
    NSInteger indexOfObject(T obj) @selector("indexOfObject:");

    /**
        Returns by reference a C array of objects over which the sender should iterate, 
        and as the return value the number of objects in the array.
    */
    NSUInteger countByEnumeratingWithState(NSFastEnumerationState* state, id* stackbuf, NSUInteger len) @selector("countByEnumeratingWithState:objects:count:");

    /**
        Gets the index of the provided object.
    
        Returns -1 if not found.
    */
    extern(D)
    ptrdiff_t find(T obj) => indexOfObject(obj);

    /**
        Allows iterating over the array.
    */
    extern(D)
    final
    int opApply(scope iter_func!T dg) {
        foreach (i; 0..length) {
            int result = iter_func_t!T(this[i], dg);
            if (result)
                return result;
        }
        return 0;
    }

    /**
        Allows iterating over the array in reverse.
    */
    extern(D)
    final
    int opApplyReverse(scope iter_func!T dg) {
        foreach (i; 0..length) {
            int result = iter_func_t!T(this[i], dg);
            if (result)
                return result;
        }
        return 0;
    }

    /**
        Allows iterating over the array, with index.
    */
    extern(D)
    final
    int opApply(scope iter_i_func!T dg) {
        foreach (i; 0..length) {
            int result = iter_i_func_t!T(i, this[i], dg);
            if (result)
                return result;
        }
        return 0;
    }

    /**
        Allows iterating over the array in reverse, with index.
    */
    extern(D)
    final
    int opApplyReverse(scope iter_i_func!T dg) {
        foreach (i; 0..length) {
            int result = iter_i_func_t!T(i, this[i], dg);
            if (result)
                return result;
        }
        return 0;
    }
    
    /// Allows indexing the array using D semantics.
    extern(D)
    final
    auto opIndex(size_t idx) {
        return this.objectAtIndex(idx);
    }

    /// For D compat.
    alias length = count;
    alias opDollar = length;
}

/**
    A Mutable NSArray
*/
extern(Objective-C)
extern class NSMutableArray(T) : NSArray!T {
@nogc nothrow:
public:

    /**
        Allocates a new NSMutableArray
    */
    override static NSMutableArray!T alloc() @selector("alloc");

    /**
        Returns a NSMutableArray object.
    */
    override NSMutableArray!T init() @selector("init");

    /**
        Empties the array of all its elements.
    */
    extern(D)
    final
    void clear() {
        this.message!void("removeAllObjects");
    }

    /**
        Removes the first object in the array 
    */
    extern(D)
    final
    void popFront() {
        if (length > 0) this.remove(0);
    }

    /**
        Removes the object with the highest-valued index in the array 
    */
    void popBack() @selector("removeLastObject");

    /**
        Removes all occurrences in the array of a given object.
    */
    void remove(DRTBindable value) @selector("removeObject:");

    /**
        Removes the object at index
    */
    void remove(NSUInteger index) @selector("removeObjectAtIndex:");

    /**
        Sorts the array using the sorting function provided.
    */
    void sort(NSInteger function(DRTBindable, DRTBindable, void*) compareFunc, void* context=null) @selector("sortUsingFunction:context:");

    /**
        Sets the receiving array’s elements to those in another given array.
    */
    extern(D)
    final
    void opAssign(NSArray other) {
        this.message!void("setArray:", other);
    }

    /**
        Inserts a given object at the end of the array.
    */
    extern(D)
    final
    void opOpAssign(string op = "~")(DRTBindable value) {
        this.message!void("addObject:", value);
    }
    
    /**
        Inserts a given object into the array’s contents at a given index.
    */
    extern(D)
    final
    void opIndexAssign(DRTBindable value, size_t index) {
        this.message!void("insertObject:atIndex:", value, index);
    }
}

@("NSArray: multiple template instantiation")
unittest {
    NSArray!NSObject objarray;
    NSArray!NSString strarray;
}

@("NSArray: create and index")
unittest {
    NSString myString = NSString.create("A");
    NSString myString2 = NSString.create("B");
    NSString[2] darray = [myString, myString2];

    auto myArray = NSArray!(NSString).create(darray);

    foreach(i; 0..myArray.length) {
        assert(myArray[i].isEqual(darray[i]));
    }
}

@("NSArray: foreach")
unittest {
    NSString myString = NSString.create("A");
    NSString myString2 = NSString.create("B");
    NSString[2] darray = [myString, myString2];

    auto myArray = NSArray!(NSString).create(darray);

    foreach(item; myArray)
        assert(item !is null);

    foreach_reverse(item; myArray)
        assert(item !is null);
}