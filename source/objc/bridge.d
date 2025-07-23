/**
    Foundation<->CoreFoundation Bridge.

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module objc.bridge;
import numem.core.meta;
import numem.core.traits;
import numem;

import corefoundation.core : CFTypeRef;
import foundation : NSObjectProtocol;

/**
    Attribute which can be applied to types to tell Objective-D that the 
    symbol safely can be bridged to the other.
*/
struct objd_bridge(Allowed...){
    alias allowed = Allowed;
} 

/**
    Allows to safely bridge-cast between CoreFoundation and Foundation
    types.
*/
pragma(inline)
To __bridge(To, From)(From from) @nogc @trusted pure {
    static assert(objd_can_bridge!(To, From), From.stringof~" can't safely be bridged to "~To.stringof~"!");

    return *cast(To*)&from;
}

/**
    Casts a Foundation object to a CoreFoundation object, transferring the ownership
    to CoreFoundation.

    Params:
        from = A Objective-C class which can be bridge-cast to $(D To).

    Returns:
        CoreFoundation object with the CF refcount increased by 1.
*/
pragma(inline)
To __bridge_retained(To, From)(From from) @nogc @trusted pure if (is(To : NSObjectProtocol)) {
    static assert(objd_can_bridge!(To, From), From.stringof~" can't safely be bridged to "~To.stringof~"!");

    return cast(To)CFBridgingRetain(*cast(From*)&from);
}

/**
    Casts a CoreFoundation object to a Foundation object, transferring the ownership
    to Foundation.

    Params:
        from = A CFType which can be bridge-cast to $(D To).

    Returns:
        Foundation object with the CF refcount decreased by 1.
*/
pragma(inline)
To __bridge_transfer(To, From)(From from) @nogc @trusted pure if (is(To : CFTypeRef)) {
    static assert(objd_can_bridge!(To, From), From.stringof~" can't safely be bridged to "~To.stringof~"!");

    return cast(To)CFBridgingRelease(*cast(From*)&from);
}

/**
    Gets whether 2 types can be safely bridged between CoreFoundation
    and Foundation
*/
enum canBridgeBetween(T, U) =
    objd_sym_bridgable!(T, U);

@("CF-NS Bridge")
unittest {
    import foundation.nsstring;
    import corefoundation.cfstring;

    NSString myString = NSString.create("Hello, world!");

    CFStringRef myBridgedString = __bridge!CFStringRef(myString);
    myString = __bridge!NSString(myBridgedString);
    assert(myString == "Hello, world!");
}


private:

extern(C) extern void* CFBridgingRetain(void*);     // To CF
extern(C) extern void* CFBridgingRelease(void*);    // From CF

template objd_can_bridge(To, From) {
    alias toUda = getUDAs!(To, objd_bridge);
    alias fromUda = getUDAs!(From, objd_bridge);
    template __is_bridagable(ToCheck) {
        template __is_bridagable(T) {
            enum __is_bridagable = is(T == ToCheck);
        }
    }

    static foreach(uda; AliasSeq!(fromUda, toUda)) {
        static if (
                !is(typeof(objd_can_bridge) == bool) && 
                (anySatisfy!(__is_bridagable!To, uda.allowed) || 
                anySatisfy!(__is_bridagable!From, uda.allowed))
        ) enum objd_can_bridge = true;
    }

    static if(!is(typeof(objd_can_bridge) == bool))
        enum objd_can_bridge = false;
}