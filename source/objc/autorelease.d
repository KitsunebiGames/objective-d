/**
    Auto Release Pools

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module objc.autorelease;
import objc.rt;

/**
    Creates an auto-release pool scope with the given delegate.

    Params:
        scope_ =    The auto release pool scope to create.
                    said scope is not allowed to allocate on the GC.
*/
@trusted
void autoreleasepool(scope void delegate() @nogc scope_) @nogc {
    void* ctx = objc_autoreleasePoolPush();
        scope_();

    debug(trace) _objc_autoreleasePoolPrint();
    objc_autoreleasePoolPop(ctx);
}

/**
    Forcefully pushes an auto-release pool onto the auto-release pool stack.

    Returns:
        A context pointer used internally, pass it to 
        $(D autoreleasepool_pop).
    
    See_Also:
        $(D autoreleasepool)
        $(D autoreleasepool_pop)
*/
arpool_ctx autoreleasepool_push() @nogc nothrow @system {
    return arpool_ctx(objc_autoreleasePoolPush());
}

/**
    Forcefully pops an auto-release pool from the auto-release pool stack.

    Params:
        ctx =   A context pointer used internally, get itfrom 
                $(D autoreleasepool_push).
    
    See_Also:
        $(D autoreleasepool)
        $(D autoreleasepool_push)
*/
void autoreleasepool_pop(arpool_ctx ctx) @nogc nothrow @system {
    return objc_autoreleasePoolPop(ctx.ctxptr);
}

/// Opaque type for auto release pool contexts.
struct arpool_ctx { void* ctxptr; alias ctxptr this; }

private:
extern(C) @nogc nothrow:

// Auto release pool
extern void* objc_autoreleasePoolPush();
extern void  objc_autoreleasePoolPop(void*);