/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Implementation of auto release pool blocks.
*/
module objc.autorelease;
import objc.rt;

import objc.utils;

/**
    Creates an auto-release pool scope with the given delegate.
*/
@trusted
void autoreleasepool(scope void delegate() scope_) {
    auto scope_fn = assumeNoGC!(typeof(scope_))(scope_);
    
    void* ctx = objc_autoreleasePoolPush();
        scope_fn();

    debug(trace) _objc_autoreleasePoolPrint();

    objc_autoreleasePoolPop(ctx);
}

/**
    Forcefully pushes an auto-release pool onto the auto-release pool stack.
*/
@system
arpool_ctx autoreleasepool_push() {
    return arpool_ctx(objc_autoreleasePoolPush());
}

/**
    Forcefully pops an auto-release pool from the auto-release pool stack.
*/
@system
void autoreleasepool_pop(arpool_ctx ctx) {
    return objc_autoreleasePoolPop(ctx.ctxptr);
}

/// Opaque type for auto release pool contexts.
struct arpool_ctx { void* ctxptr; alias ctxptr this; }

private:
extern(C) @nogc nothrow:

// Auto release pool
extern void* objc_autoreleasePoolPush();
extern void  objc_autoreleasePoolPop(void*);