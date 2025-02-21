/**
    NSObject

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.nsobject;
import foundation;
import objc.basetypes;
import objc;
import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

/**
    Base class of all Objective-C classes.
*/
extern(Objective-C)
extern class NSObject :  NSObjectProtocol {
@nogc nothrow:
protected:
    
    /**
        Gets a pointer to the given ivar in the object.

        Params:
            name = Name of the ivar to get.
        
        Returns:
            A pointer to said ivar or $(D null)
            if an ivar with that name does not exist.
    */
    extern(D)
    T getVariable(T)(const(char)* name) {
        return self.getVariable!T(name);
    }
public:

    /**
        Returns a Boolean value that indicates whether the receiving 
        class is a subclass of, or identical to, a given class.
    */
    static bool isSubclassOf(Class klass) @selector("isSubclassOfClass:");

    /**
        Returns a Boolean value that indicates whether instances of 
        the receiver are capable of responding to a given selector.
    */
    static bool respondsTo(SEL selector) @selector("instancesRespondToSelector:");

    /**
        Returns a Boolean value that indicates whether the target 
        conforms to a given protocol.
    */
    static bool conformsTo(Protocol protocol) @selector("conformsToProtocol:");

    /**
        Locates and returns the address of the implementation of the 
        instance method identified by a given selector.
    */
    static IMP methodFor(SEL selector) @selector("instanceMethodForSelector:");

    /**
        Cancels perform requests previously registered with the `perform(SEL, id, bool)`
        instance method.
    */
    static void cancelRequests(id target) @selector("cancelPreviousPerformRequestsWithTarget:");

    /**
        Cancels perform requests previously registered with the `perform(SEL, id, bool)`
        instance method.
    */
    static void cancelRequests(id target, SEL selector, id arg) @selector("cancelPreviousPerformRequestsWithTarget:selector:object:");

    /**
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(inout(id) obj) inout @selector("isEqual:");

    /**
        Returns a Boolean value that indicates whether the receiver and a given object are equal.
    */
    bool isEqual(inout(NSObject) obj) inout @selector("isEqual:");

    /**
        Returns the class object for the receiver’s class.
    */
    Class class_() @selector("class");

    /**
        Returns the class object for the receiver’s superclass.
    */
    Class superclass() @selector("superclass");

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
        Returns a string that represents the contents of the receiving class.
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
        Invokes a method of the receiver on the current thread using the 
        default mode after a delay.
    */
    void perform(SEL selector, id argument, NSTimeInterval delay) @selector("performSelector:withObject:afterDelay:");

    /**
        Invokes a method of the receiver on the main thread using the default mode.
    */
    void performOnMain(SEL selector, id argument, bool wait) @selector("performSelectorOnMainThread:withObject:waitUntilDone:");

    /**
        Locates and returns the address of the receiver’s implementation 
        of a method so it can be called as a function.
    */
    IMP methodFor(SEL selector) @selector("methodForSelector:");

    /**
        Returns the object returned by copyWithZone: where the zone is nil.
    */
    id copy() @selector("copy");

    /**
        eturns the object returned by mutableCopyWithZone: where the zone is nil.
    */
    id mutableCopy() @selector("mutableCopy");

    /**
        Handles messages the receiver doesn’t recognize.
    */
    void handleUnrecognizedSelector(SEL selector) @selector("doesNotRecognizeSelector:");

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

/**
    Gets whether the given type is an Objective-C class instance.
*/
enum isObjcClassInstance(T) =
    ((is(T == class) || is(T == interface)) && 
        __traits(getLinkage, T) == "Objective-C") ||
    is(T : id);

/**
    Gets the name of an Objective-C compatible class.
*/
string classname(T)(T obj) if(is(T : NSObjectProtocol)) {
    import core.stdc.string : strlen;
    auto name = obj.self.name();
    return cast(string)name[0..strlen(name)];
}

/**
    Retains a single reference for `value` and returns it.
*/
auto retained(T)(auto ref inout(T) value) if (isObjcClassInstance!T) {
    if (value !is null)
        (cast(T)value).retain();
    return value;
}

/**
    Releases a single reference for `value` and returns it.
*/
auto released(T)(auto ref inout(T) value) if (isObjcClassInstance!T) {
    if (value !is null)
        (cast(T)value).release();
    return value;
}

/**
    Queues `value` up for an auto-release and returns it.
*/
auto autoreleased(T)(auto ref inout(T) value) if (isObjcClassInstance!T) {
    if (value !is null)
        (cast(T)value).autorelease();
    return value;
}

