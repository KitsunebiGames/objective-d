/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Interface to the Objective-C Runtime.
*/
module objc.rt;
import objc.block;

public import core.stdc.stdlib : free;
public import core.stdc.config : __c_complex_double;

/**
    Specifies the superclass of an instance.

    It specifies the class definition of the particular superclass that should be messaged.
*/
struct objc_super {

    /**
        Specifies an instance of a class.
    */
    id reciever;

    /**
        Specifies the particular superclass of the instance to message.
    */
    Class superClass;
}

struct objc_method_description_t {

    /**
        The name of the method at runtime. 
    */
    SEL name;

    /**
        The types of the method arguments.
    */
    char* types;
}

struct objc_property_attribute_t {

    /**
        The name of the attribute.
    */
    const(char)* name;

    /**
        The value of the attribute (usually empty).
    */
    const(char)* value;
}

/**
    Type to specify the behavior of an association.
*/
enum objc_AssociationPolicy : size_t {
    OBJC_ASSOCIATION_ASSIGN = 0,
    OBJC_ASSOCIATION_COPY = 1403,
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
    OBJC_ASSOCIATION_RETAIN = 1401,
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1
}


/**
    Base opaque type handle
*/
struct objc_any;
alias any = objc_any*;

/**
    Objective-C Class type.
*/
struct Class {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

    /**
        A "none" class.
    */
    enum none = Class(cast(any)null);

    /**
        A "stub" class.
    */
    enum stub = Class(cast(any)cast(void*)1);

    /**
        Creates a new class and metaclass.
    */
    static Class allocateClassPair(Class superclass, const(char)* name, size_t extraBytes) => objc_allocateClassPair(
        superclass, name, extraBytes);

    /**
        Returns the class definition of a specified class.
    */
    static Class lookup(const(char)* name) => objc_lookUpClass(name);

    /**
        Returns the metaclass definition of a specified class.
    */
    static id lookupMetaclass(const(char)* name) => objc_getMetaClass(name);

    /**
        Creates and returns a slice of pointers to all registered class definitions.

        you are responsible for freeing the returned slice by calling
        free on its .ptr value! 
    */
    static Class[] classList() {
        uint classCount;
        return objc_copyClassList(&classCount)[0 .. classCount];
    }

    /**
        The version number of a class definition.
    */
    @property int version_() => class_getVersion(this);
    @property void version_(int value) => class_setVersion(this, value);

    /**
        Returns the name of a class.
    */
    @property const(char)* name() => class_getName(this);

    /**
        Returns the name of the dynamic library a class originated from.
    */
    @property const(char)* imageName() => class_getImageName(this);

    /**
        Returns the superclass of a class.
    */
    @property Class superclass() => class_getSuperclass(this);

    /**
        Returns a Boolean value that indicates whether a class object is a metaclass.
    */
    @property bool isMetaClass() => class_isMetaClass(this);

    /**
        Returns the size of instances of a class.
    */
    @property size_t instanceSize() => class_getInstanceSize(this);

    /**
        Describes the instance variables declared by a class.

        you are responsible for freeing the returned slice by calling
        free on its .ptr value! 
    */
    @property Ivar[] ivars() {
        uint ivarCount;
        auto ivars = class_copyIvarList(this, &ivarCount);
        return ivars[0 .. ivarCount];
    }

    /**
        Describes the instance variables declared by a class.

        you are responsible for freeing the returned slice by calling
        free on its .ptr value! 
    */
    @property objc_property_t[] properties() {
        uint propCount;
        auto props = class_copyPropertyList(this, &propCount);
        return props[0 .. propCount];
    }

    /**
        Describes the instance methods implemented by a class.

        you are responsible for freeing the returned slice by calling
        free on its .ptr value! 
    */
    @property Method[] methods() {
        uint methodCount;
        auto methods = class_copyMethodList(this, &methodCount);
        return methods[0 .. methodCount];
    }

    /**
        Describes the protocols adopted by a class.

        you are responsible for freeing the returned slice by calling
        free on its .ptr value! 
    */
    @property Protocol[] protocols() {
        uint protoCount;
        auto protos = class_copyProtocolList(this, &protoCount);
        return protos[0 .. protoCount];
    }

    /**
        Returns a description of the Ivar layout for a given class. 
    */
    @property const(ubyte)* ivarLayout() => class_getIvarLayout(this);

    /**
        Returns a description of the layout of weak Ivars for a given class.
    */
    @property const(ubyte)* weakIvarLayout() => class_getWeakIvarLayout(this);

    /**
        Returns a Boolean value that indicates whether instances of a class respond 
        to a particular selector.
    */
    bool respondsToSelector(SEL sel) => class_respondsToSelector(this, sel);

    /**
        Returns a Boolean value that indicates whether a class conforms 
        to a given protocol.
    */
    bool conformsTo(Protocol proto) => class_conformsToProtocol(this, proto);

    /**
        Returns the Ivar for a specified instance variable of a given class.
    */
    Ivar getInstanceVariable(const(char)* name) => class_getInstanceVariable(this, name);

    /**
        Returns the Ivar for a specified class variable of a given class.
    */
    Ivar getClassVariable(const(char)* name) => class_getClassVariable(this, name);

    /**
        Returns a property with a given name of a given class.
    */
    objc_property_t getProperty(const(char)* name) => class_getProperty(this, name);

    /**
        Returns a specified instance method for a given class.
    */
    Method getInstanceMethod(SEL name) => class_getInstanceMethod(this, name);

    /**
        Returns a pointer to the data structure describing a given class method for a given class.
    */
    Method getClassMethod(SEL name) => class_getClassMethod(this, name);

    /**
        Returns the function pointer that would be called if a particular 
        message were sent to an instance of a class.
    */
    IMP getMethodImplementation(ReturnType)(SEL name) {
        version (AArch64)
            return class_getMethodImplementation(this, name);
        else {
            static if (is(ReturnType == struct))
                return class_getMethodImplementation_stret(this, name);
            else
                return class_getMethodImplementation(this, name);
        }
    }

    /**
        Sends a message to a class.
    */
    T send(T, Args...)(SEL selector, Args args) {
        return _d_objc_msgSend!T(ptr, selector, args);
    }

    T send(T, Args...)(const(char)* selector, Args args) => this.send!T(SEL.get(selector), args);

    /**
        Adds a protocol to a class.
    */
    bool addProtocol(Protocol proto) {
        return class_addProtocol(this, proto);
    }

    /**
        Adds a property to a class.
    */
    bool addProperty(const(char)* name, const(objc_property_attribute_t)* attributes, uint attributeCount) {
        return class_addProperty(this, name, attributes, attributeCount);
    }

    bool addProperty(const(char)* name, const(objc_property_attribute_t)[] attributes) => this.addProperty(name, attributes
            .ptr, cast(uint) attributes.length);

    /**
        Replaces a property of a class.
    */
    void replaceProperty(const(char)* name, const(objc_property_attribute_t)* attributes, uint attributeCount) =>
        class_replaceProperty(this, name, attributes, attributeCount);
    void replaceProperty(const(char)* name, const(objc_property_attribute_t)[] attributes) =>
        class_replaceProperty(this, name, attributes.ptr, cast(uint) attributes.length);

    /**
        Adds a new method to a class with a given name and implementation.
    */
    bool addMethod(SEL name, IMP impl, const(char)* types) {
        return class_addMethod(this, name, impl, types);
    }

    /**
        Replaces the implementation of a method for a given class.
    */
    IMP replaceMethod(SEL name, IMP impl, const(char)* types) {
        return class_replaceMethod(this, name, impl, types);
    }

    /**
        Adds a new instance variable to a class. 
    */
    bool addIvar(const(char)* name, int size, ubyte alignment, const(char)* types) {
        return class_addIvar(this, name, size, alignment, types);
    }

    /**
        Sets the Ivar layout for a given class. 
    */
    void setIvarLayout(const(ubyte)* layout) {
        class_setIvarLayout(this, layout);
    }

    /**
        Sets the layout for weak Ivars for a given class. 
    */
    void setWeakIvarLayout(const(ubyte)* layout) {
        class_setWeakIvarLayout(this, layout);
    }

    /**
        Registers a class that was allocated using Class.allocateClassPair.
    */
    void register() {
        objc_registerClassPair(this);
    }

    /**
        Creates an instance of a class, allocating memory for the class 
        in the default malloc memory zone.
    */
    id create(size_t extraBytes = 0) {
        return class_createInstance(this, extraBytes);
    }

    /**
        Creates an instance of a class at the specified location.

        The location at which to allocate an instance of the cls class.
        `location` must point to at least `instanceSize` bytes of well-aligned, zero-filled memory.
    */
    id createAt(void* location) {
        return objc_constructInstance(this, location);
    }

    /**
        Calls the `alloc` function for the object.
    */
    id alloc() {
        return this.send!id("alloc");
    }

    /**
        Used by Foundation's Key-Value Observing.
    */
    Class duplicate(const(char)* name, size_t extraBytes) {
        return objc_duplicateClass(this, name, extraBytes);
    }

    /**
        Destroys a class and its associated metaclass.

        ### NOTE
        > Do not call this function if instances of the class or any subclass exist.
    */
    @system
    void dispose() {
        objc_disposeClassPair(this);
    }
}

/**
    Objective-C Protocol type.
*/
struct Protocol {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

    /**
        Returns a specified protocol.
    */
    static Protocol get(const(char)* name) => objc_getProtocol(name);

    /**
        Creates a new protocol instance.

        You must register the returned protocol instance with the `register` function.
    */
    static Protocol allocate(const(char)* name) => objc_allocateProtocol(name);

    /**
        Returns a slice of all the protocols known to the runtime. 

        you are responsible for freeing the returned slice by calling
        free on its .ptr value! 
    */
    static @property Protocol[] all() {
        uint protoCount;
        return objc_copyProtocolList(&protoCount)[0 .. protoCount];
    }

    /**
        Returns a the name of a protocol.
    */
    @property const(char)* name() => protocol_getName(this);

    /**
        Returns an array of the properties declared by a protocol.

        you are responsible for freeing the returned slice by calling
        free on its .ptr value! 
    */
    @property objc_property_t[] properties() {
        uint propCount;
        auto props = protocol_copyPropertyList(this, &propCount);
        return props[0 .. propCount];
    }

    /**
        Returns a Boolean value that indicates whether one protocol conforms to another protocol.
    */
    bool conformsTo(Protocol other) => protocol_conformsToProtocol(this, other);

    /**
        Sends a message to a protocol.
    */
    T send(T, Args...)(SEL selector, Args args) {
        return _d_objc_msgSend!T(ptr, selector, args);
    }

    T send(T, Args...)(const(char)* selector, Args args) => this.send!T(SEL.get(selector), args);

    /**
        Adds a registered protocol to another protocol that is under construction.
    */
    void addProtocol(Protocol addition) {
        protocol_addProtocol(this, addition);
    }

    /**
        Adds a method to a protocol.
    */
    void addMethod(SEL name, const(char)* types, bool isRequiredMethod, bool isInstanceMethod) {
        protocol_addMethodDescription(this, name, types, isRequiredMethod, isInstanceMethod);
    }

    /**
        Returns a method description structure for a specified method of a given protocol.
    */
    objc_method_description_t getMethod(SEL selector, bool isRequiredMethod, bool isInstanceMethod) =>
        protocol_getMethodDescription(this, selector, isRequiredMethod, isInstanceMethod);

    /**
        Adds a property to a protocol that is under construction.
    */
    void addProperty(const(char)* types, const(objc_property_attribute_t)* attributes, uint attributeCount, bool isRequiredProperty, bool isInstanceProperty) =>
        protocol_addProperty(this, name, attributes, attributeCount, isRequiredProperty, isInstanceProperty);
    void addProperty(const(char)* types, const(objc_property_attribute_t)[] attributes, bool isRequiredMethod, bool isInstanceMethod) =>
        protocol_addProperty(this, name, attributes.ptr, cast(uint) attributes.length, isRequiredMethod, isInstanceMethod);

    /**
        Returns the specified property of a given protocol.
    */
    objc_property_t getProperty(const(char)* name, bool isRequiredProperty, bool isInstanceProperty) =>
        protocol_getProperty(this, name, isRequiredProperty, isInstanceProperty);

    /**
        Registers a newly created protocol with the Objective-C runtime.

        After a protocol is successfully registered, it is immutable and ready to use.
    */
    void register() {
        objc_registerProtocol(this);
    }

    /**
        Returns a Boolean value that indicates whether two protocols are equal.
    */
    bool opEquals(const(Protocol) other) const => protocol_isEqual(cast(Protocol) this, cast(
            Protocol) other);
}

/**
    Objective-C Method type.
*/
struct Method {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

    /**
        Returns the name (of the selector) of a method.
    */
    @property const(char)* name() => selector.name;

    /**
        Returns the selector of a method.
    */
    @property SEL selector() => method_getName(this);

    /**
        Returns a string describing a method's parameter and return types.
    */
    @property const(char)* type() => method_getTypeEncoding(this);

    /**
        Returns the number of arguments accepted by a method.
    */
    @property uint argCount() => method_getNumberOfArguments(this);

    /**
        Returns a method description structure for a specified method.
    */
    @property objc_method_description_t* description() => method_getDescription(this);

    /**
        Returns the implementation of a method.
    */
    @property IMP implementation() => method_getImplementation(this);
    @property IMP implementation(IMP impl) => method_setImplementation(this, impl);

    /**
        Calls the implementation of a specified method.
    */
    T invoke(T, Args...)(id invokeOn, Args args) {
        return _d_method_invoke!T(invokeOn, this, args);
    }

    /**
        Exchanges the implementations of two methods.
    */
    void exchangeImplementations(Method other) {
        method_exchangeImplementations(this, other);
    }
}

/**
    Objective-C Instance variable type.
*/
struct Ivar {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

    /**
        Returns the name of an instance variable.
    */
    @property const(char)* name() => ivar_getName(this);

    /**
        Returns the type string of an instance variable.
    */
    @property const(char)* type() => ivar_getTypeEncoding(this);

    /**
        Returns the offset of an instance variable.
    */
    @property ptrdiff_t offset() => ivar_getOffset(this);
}

/**
    Objective-C Category type.
*/
struct Category {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

}

/**
    An Objective-C declared property.
*/
struct objc_property_t {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

    /**
        Returns the name of a property.
    */
    @property const(char)* name() => property_getName(this);

    /**
        Returns the name of a property.
    */
    @property const(char)* attributes() => property_getAttributes(this);
}

/**
    A pointer to an instance of a class.

    The id *may* be wrapped to a D type.
*/
struct id {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

    /**
        Returns a null object.
    */
    static id none() => id(null);

    /**
        Loads the object referenced by a weak pointer and returns it.
    */
    static id loadWeak(id* location) => objc_loadWeak(location);

    /**
        Returns the superclass of a class.
    */
    @property Class class_() => object_getClass(this);
    @property Class class_(Class klass) => object_setClass(this, klass);

    /**
        Convenience function that retuns the superclass of this object's class.
    */
    @property Class superclass() => this.class_.superclass;

    /**
        Returns a pointer to any extra bytes allocated with a instance given object.
    */
    @property void* indexedIvars() => object_getIndexedIvars(this);

    /**
        Returns the class name of a given object.
    */
    @property const(char)* name() => object_getClassName(this);

    /**
        Gets whether the object is uniquely referenced.
    */
    @property bool isUniquelyReferenced() => objc_isUniquelyReferenced(this);

    /**
        Returns a copy of a given object. 
    */
    id copy(size_t extraSize = 0) {
        return object_copy(this, this.class_.instanceSize() + extraSize);
    }

    /**
        Sends a message with a simple return value to an instance of a class.
    */
    T send(T, Args...)(SEL selector, Args args) {
        return _d_objc_msgSend!T(ptr, selector, args);
    }

    T send(T, Args...)(const(char)* selector, Args args) =>
        this.send!T(SEL.get(selector), args);

    /**
        Sends a message with a simple return value to the 
        superclass of an instance of a class.
    */
    T send(T, Args...)(Class superclass, SEL selector, Args args) {
        objc_super super_ = {reciever: this, superClass: superclass};
        return _d_objc_msgSendSuper!T(&super_, selector, args);
    }

    T send(T, Args...)(Class superclass, const(char)* selector, Args args) =>
        this.send!T(superclass, SEL.get(selector), args);

    /**
        Returns the value associated with a given object for a given key. 
    */
    id getAssociation(const(void)* key) {
        return objc_getAssociatedObject(this, key);
    }

    /**
        Sets an associated value for a given object using a given key and association policy. 
    */
    void associate(const(void)* key, id value, objc_AssociationPolicy policy) {
        objc_setAssociatedObject(this, key, value, policy);
    }

    /**
        Removes an associated value for a given object using a given key. 
    */
    void disassociate(const(void)* key) {
        objc_setAssociatedObject(this, key, id(null), objc_AssociationPolicy
                .OBJC_ASSOCIATION_ASSIGN);
    }

    /**
        Removes all associations for a given object.
    */
    void disassociateAll() {
        objc_removeAssociatedObjects(this);
    }

    /**
        Obtains the value of an instance variable of a class instance.
    */
    T getVariable(T)(const(char)* name) {
        T outValue;
        object_getInstanceVariable(this, name, cast(void**)&outValue); // @suppress(dscanner.unused_result)
        return outValue;
    }

    /**
        Changes the value of an instance variable of a class instance.
    */
    void setVariable(T)(const(char)* name, T value) {
        object_setInstanceVariable(this, name, cast(void*) value); // @suppress(dscanner.unused_result)
    }

    /**
        Stores a value in a __weak variable.
    */
    id storeWeak(id* location) {
        return objc_storeWeak(location, this);
    }

    /**
        Calls the `init` function for the object.
    */
    id initialize() {
        return this.send!id("init");
    }

    /**
        Adds a reference
    */
    id retain() {
        return objc_retain(this);
    }

    /**
        Removes a reference
    */
    void release() {
        objc_release(this);
    }

    /**
        Automatically release at the end of an auto-release pool.
    */
    id autorelease() {
        return objc_autorelease(this);
    }

    /**
        Destroys an instance of a class without freeing memory and 
        removes any of its associated references.
    */
    void* destruct() {
        return objc_destructInstance(this);
    }

    /**
        Frees the memory occupied by a given object. 
    */
    void dispose() {
        object_dispose(this); // @suppress(dscanner.unused_result)
    }
}

/**
    Objective-C Selector type.
*/
struct SEL {
nothrow @nogc:
public:
    any ptr;
    alias ptr this;

    /**
        Registers a method with the Objective-C runtime system, 
        maps the method name to a selector, 
        and returns the selector value.
    */
    static SEL register(const(char)* name) => sel_registerName(name);
    static SEL get(const(char)* name) => sel_getUid(name);

    /**
        Returns the name of the method specified by a given selector.
    */
    @property const(char)* name() => sel_getName(this);

    /**
        Returns a Boolean value that indicates whether two selectors are equal.
    */
    bool opEquals(const(SEL) other) const => sel_isEqual(cast(SEL) this, cast(SEL) other);
}

/**
    A pointer to the start of a method implementation.
*/
alias IMP = extern (C) id function(id, SEL, ...) @nogc nothrow;

/**
    Disassociates a block from an IMP that was created using `fromBlock`
    and releases the copy of the block that was created.
*/
bool removeBlock(IMP imp) {
    return imp_removeBlock(imp);
}

/**
    Creates an IMP from a block
*/
IMP fromBlock(BlockT)(BlockT block) if (is(BlockT == Block!(id, Params), Params...)) {
    return imp_implementationWithBlock(cast(void*)&block);
}

extern (C) @nogc nothrow:

private {

    // Working with Classes
    // NOTE: Platform implementation differs
    // SEE: https://github.com/opensource-apple/objc4/blob/master/runtime/message.h
    extern const(char)* class_getName(Class cls);
    extern Class class_getSuperclass(Class cls);
    extern bool class_isMetaClass(Class cls);
    extern size_t class_getInstanceSize(Class cls);
    extern Ivar class_getInstanceVariable(Class cls, const(char)* name);
    extern Ivar class_getClassVariable(Class cls, const(char)* name);
    extern bool class_addIvar(Class cls, const(char)* name, int size, ubyte alignment, const(
            char)* types);
    extern Ivar* class_copyIvarList(Class cls, uint* outCount);
    extern const(ubyte)* class_getIvarLayout(Class cls);
    extern void class_setIvarLayout(Class cls, const(ubyte)* layout);
    extern const(ubyte)* class_getWeakIvarLayout(Class cls);
    extern void class_setWeakIvarLayout(Class cls, const(ubyte)* layout);
    extern objc_property_t class_getProperty(Class cls, const(char)* name);
    extern objc_property_t* class_copyPropertyList(Class cls, uint* outCount);
    extern bool class_addMethod(Class cls, SEL name, IMP imp, const(char)* types);
    extern Method class_getInstanceMethod(Class cls, SEL name);
    extern Method class_getClassMethod(Class cls, SEL name);
    extern Method* class_copyMethodList(Class cls, uint* outCount);
    extern IMP class_replaceMethod(Class cls, SEL name, IMP imp, const(char)* types);
    extern IMP class_getMethodImplementation(Class cls, SEL name);
    version (AArch64) {
    } else
        extern IMP class_getMethodImplementation_stret(Class cls, SEL name);
    extern bool class_respondsToSelector(Class cls, SEL sel);
    extern bool class_addProtocol(Class cls, Protocol protocol);
    extern bool class_addProperty(Class cls, const(char)* name, const(objc_property_attribute_t)* attributes, uint attributeCount);
    extern void class_replaceProperty(Class cls, const(char)* name, const(
            objc_property_attribute_t)* attributes, uint attributeCount);
    extern bool class_conformsToProtocol(Class cls, Protocol protocol);
    extern Protocol* class_copyProtocolList(Class cls, uint* outCount);
    extern int class_getVersion(Class cls);
    extern void class_setVersion(Class cls, int version_);

    // Adding Classes
    extern Class objc_allocateClassPair(Class superclass, const(char)* name, size_t extraBytes);
    extern void objc_disposeClassPair(Class cls);
    extern void objc_registerClassPair(Class cls);
    extern Class objc_duplicateClass(Class original, const(char)* name, size_t extraBytes);

    // Instantiating Classes
    extern id class_createInstance(Class cls, size_t extraBytes);
    extern id objc_constructInstance(Class cls, void* bytes);
    extern void* objc_destructInstance(id obj);

    // Working with Instances
    extern id object_copy(id obj, size_t size);
    extern id object_dispose(id obj);
    extern Ivar object_setInstanceVariable(id obj, const(char)* name, void* value);
    extern Ivar object_getInstanceVariable(id obj, const(char)* name, void** outValue);
    extern void* object_getIndexedIvars(id obj);
    extern id object_getIvar(id obj, Ivar ivar);
    extern void object_setIvar(id obj, Ivar ivar, id value);
    extern const(char)* object_getClassName(id obj);
    extern Class object_getClass(id obj);
    extern Class object_setClass(id obj, Class cls);

    // ARC
    extern id objc_retain(id obj);
    extern void objc_release(id obj);
    extern id objc_autorelease(id obj);
    extern bool objc_isUniquelyReferenced(id obj);

    // Obtaining Class Definitions
    extern int objc_getClassList(Class* buffer, int bufferCount);
    extern Class* objc_copyClassList(uint* outCount);
    extern Class objc_lookUpClass(const(char)* name);
    extern id objc_getClass(const(char)* name);
    extern id objc_getMetaClass(const(char)* name);

    // Working with Instance Variables
    extern const(char)* ivar_getName(Ivar v);
    extern const(char)* ivar_getTypeEncoding(Ivar v);
    extern ptrdiff_t ivar_getOffset(Ivar v);

    // Associative References
    extern void objc_setAssociatedObject(id object, const(void)* key, id value, objc_AssociationPolicy policy);
    extern id objc_getAssociatedObject(id object, const(void)* key);
    extern void objc_removeAssociatedObjects(id object);

    // Sending Messages
    // NOTE: Due to the runtime declaring these functions they have to match the definition there.
    extern void* objc_msgSend(void*, void*);
    extern void* objc_msgSendSuper(void*, void*);
    version (ARM) extern void objc_msgSend_stret(void*, void*, void*);
    version (ARM) extern void objc_msgSendSuper_stret(void*, void*);
    version (X86) extern void objc_msgSend_stret(void*, void*, void*);
    version (X86) extern void objc_msgSendSuper_stret(void*, void*);
    version (X86) extern real objc_msgSend_fpret(void*, void*);
    version (X86_64) extern real objc_msgSend_fpret(void*, void*);
    version (X86_64) extern real objc_msgSend_fp2ret(void*, void*);
    version (X86_64) extern void objc_msgSend_stret(void*, void*, void*);
    version (X86_64) extern void objc_msgSendSuper_stret(void*, void*);

    // Working with Methods
    // NOTE: Platform implementation differs
    // SEE: https://github.com/opensource-apple/objc4/blob/master/runtime/message.h#L232
    extern void method_invoke(id receiver, Method method, ...);
    version (ARM) extern void method_invoke_stret(id receiver, Method method, ...);
    version (X86) extern void method_invoke_stret(id receiver, Method method, ...);
    version (X86_64) extern void method_invoke_stret(id receiver, Method method, ...);
    extern SEL method_getName(Method m);
    extern IMP method_getImplementation(Method m);
    extern const(char)* method_getTypeEncoding(Method m);
    extern char* method_copyReturnType(Method m);
    extern char* method_copyArgumentType(Method m, uint index);
    extern void method_getReturnType(Method m, char* dst, size_t dst_len);
    extern uint method_getNumberOfArguments(Method m);
    extern objc_method_description_t* method_getDescription(Method m);
    extern IMP method_setImplementation(Method m, IMP imp);
    extern void method_exchangeImplementations(Method m1, Method m2);

    // Working with Libraries
    extern const(char)** objc_copyImageNames(uint* outCount);
    extern const(char)* class_getImageName(Class cls);
    extern const(char)** objc_copyClassNamesForImage(const(char)* image, uint* outCount);

    // Working with Selectors
    extern const(char)* sel_getName(SEL sel);
    extern SEL sel_registerName(const(char)* str);
    extern SEL sel_getUid(const(char)* str);
    extern bool sel_isEqual(SEL lhs, SEL rhs);

    // Working with Protocols
    extern Protocol objc_getProtocol(const(char)* name);
    extern Protocol* objc_copyProtocolList(uint* outCount);
    extern Protocol objc_allocateProtocol(const(char)* name);
    extern void objc_registerProtocol(Protocol proto);
    extern void protocol_addMethodDescription(Protocol proto, SEL name, const(char)* types, bool isRequiredMethod, bool isInstanceMethod);
    extern void protocol_addProtocol(Protocol proto, Protocol addition);
    extern void protocol_addProperty(Protocol proto, const(char)* name, const(objc_property_attribute_t)* attributes, uint attributeCount, bool isRequiredProperty, bool isInstanceProperty);
    extern const(char)* protocol_getName(Protocol proto);
    extern bool protocol_isEqual(Protocol proto, Protocol other);
    extern objc_method_description_t* protocol_copyMethodDescriptionList(Protocol proto, bool isRequiredMethod, bool isInstanceMethod, uint* outCount);
    extern objc_method_description_t protocol_getMethodDescription(Protocol proto, SEL aSel, bool isRequiredMethod, bool isInstanceMethod);
    extern objc_property_t* protocol_copyPropertyList(Protocol proto, uint* outCount);
    extern objc_property_t protocol_getProperty(Protocol proto, const(char)* name, bool isRequiredProperty, bool isInstanceProperty);
    extern Protocol* protocol_copyProtocolList(Protocol proto, uint* outCount);
    extern bool protocol_conformsToProtocol(Protocol proto, Protocol other);

    // Working with Properties
    const(char)* property_getName(objc_property_t property);
    const(char)* property_getAttributes(objc_property_t property);
    char* property_copyAttributeValue(objc_property_t property, const(char)* attributeName);
    objc_property_attribute_t* property_copyAttributeList(objc_property_t property, uint* outCount);

    // Using Objective-C Language Features
    IMP imp_implementationWithBlock(void* block);
    bool imp_removeBlock(IMP anImp);
    id objc_loadWeak(id* location);
    id objc_storeWeak(id* location, id obj);

    // HELPERS FOR MESSAGE SEND AND INVOKE.
    // SEE: https://github.com/opensource-apple/objc4/blob/master/runtime/message.h#L143
    T _d_objc_msgSend(T, Args...)(any instance, SEL selector, Args args) {
        import std.traits : isFloatingPoint;

        alias fn = T function(any, SEL, Args) @nogc nothrow;
        alias stret_fn = void function(T*, any, SEL, Args) @nogc nothrow;

        version (ARM) {

            // 32-bit ARM
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&objc_msgSend_stret)(&tmp, instance, selector, args);
                return tmp;
            } else {
                return (cast(fn)&objc_msgSend)(instance, selector, args);
            }
        } else version (X86) {

            // 32-bit X86
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&objc_msgSend_stret)(&tmp, instance, selector, args);
                return tmp;
            } else static if (isFloatingPoint!T) {
                return (cast(fn)&objc_msgSend_fpret)(instance, selector, args);
            } else {
                return (cast(fn)&objc_msgSend)(instance, selector, args);
            }
        } else version (X86_64) {

            // 64-bit X86
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&objc_msgSend_stret)(&tmp, instance, selector, args);
                return tmp;
            } else static if (is(T == float) || is(T == double) || is(T == real)) {
                return (cast(fn)&objc_msgSend_fpret)(instance, selector, args);
            } else static if (is(T == __c_complex_double)) {
                return (cast(fn)&objc_msgSend_fp2ret)(instance, selector, args);
            } else {
                return (cast(fn)&objc_msgSend)(instance, selector, args);
            }
        } else {

            // AArch64 uses msgSend in all cases.
            return (cast(fn)&objc_msgSend)(instance, selector, args);
        }
    }

    // SEE: https://github.com/opensource-apple/objc4/blob/master/runtime/message.h#L143
    T _d_objc_msgSendSuper(T, Args...)(objc_super* instance, SEL selector, Args args) {
        import std.traits : isFloatingPoint;

        alias fn = T function(objc_super*, SEL, Args) @nogc nothrow;
        alias stret_fn = void function(T*, objc_super*, SEL, Args) @nogc nothrow;

        version (ARM) {

            // 32-bit ARM
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&objc_msgSendSuper_stret)(&tmp, instance, selector, args);
                return tmp;
            } else {
                return (cast(fn)&objc_msgSendSuper)(instance, selector, args);
            }
        } else version (X86) {

            // 32-bit X86
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&objc_msgSendSuper_stret)(&tmp, instance, selector, args);
                return tmp;
            } else {
                return (cast(fn)&objc_msgSendSuper)(instance, selector, args);
            }
        } else version (X86_64) {

            // 64-bit X86
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&objc_msgSendSuper_stret)(&tmp, instance, selector, args);
                return tmp;
            } else {
                return (cast(fn)&objc_msgSendSuper)(instance, selector, args);
            }
        } else {

            // AArch64 uses msgSend in all cases.
            return (cast(fn)&objc_msgSendSuper)(instance, selector, args);
        }
    }

    T _d_method_invoke(T, Args...)(id instance, Method method, Args args) {
        alias fn = T function(id, Method, Args) @nogc nothrow;
        alias stret_fn = void function(T*, id, Method, args) @nogc nothrow;

        version (ARM) {

            // 32-bit ARM
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&method_invoke_stret)(&tmp, instance, method, args);
                return tmp;
            } else {
                return (cast(fn)&method_invoke)(instance, method, args);
            }
        } else version (X86) {

            // 32-bit X86
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&method_invoke_stret)(&tmp, instance, method, args);
                return tmp;
            } else {
                return (cast(fn)&method_invoke)(instance, method, args);
            }
        } else version (X86_64) {

            // 64-bit X86
            static if (is(T == struct)) {
                T tmp;
                (cast(stret_fn)&method_invoke_stret)(&tmp, instance, method, args);
                return tmp;
            } else {
                return (cast(fn)&method_invoke)(instance, method, args);
            }
        } else {

            // AArch64 uses msgSend in all cases.
            return (cast(fn)&objc_msgSend)(instance, method, args);
        }
    }
}
