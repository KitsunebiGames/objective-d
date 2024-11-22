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

import numem.core.memory;
import numem.core.memory.alloc : assumeNoGC;

/**
    Creates an auto-release pool scope with the given delegate.
*/
void autoreleasepool(scope void delegate() scope_) {
    auto scope_fn = assumeNoGC!(typeof(scope_))(scope_);
    
    void* ctx = objc_autoreleasePoolPush();
        scope_fn();

    debug(trace) _objc_autoreleasePoolPrint();

    objc_autoreleasePoolPop(ctx);
}


private:
extern(C) @nogc nothrow:

// Auto release pool
extern void* objc_autoreleasePoolPush();
extern void  objc_autoreleasePoolPop(void*);