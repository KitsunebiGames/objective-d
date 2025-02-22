/**
    CoreFoundation RunLoop

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfrunloop;
import corefoundation.cfallocator;
import corefoundation.cfstring;
import corefoundation.cfarray;
import corefoundation.core;
import objc;


alias CFRunLoopMode = CFStringRef;


/**
    Return codes for CFRunLoopRunInMode, identifying the reason 
    the run loop exited.
*/
enum CFRunLoopRunResult {
   kCFRunLoopRunFinished = 1,
   kCFRunLoopRunStopped = 2,
   kCFRunLoopRunTimedOut = 3,
   kCFRunLoopRunHandledSource = 4
}

//
//          CFRunLoop
//

/**
    A CFRunLoop object monitors sources of input to a task and dispatches 
    control when they become ready for processing.
*/
alias CFRunLoopRef = CFSubType!("CFRunLoop");

/**
    Returns the CFRunLoop object for the current thread.
*/
extern CFRunLoopRef CFRunLoopGetCurrent();

/**
    Returns the main CFRunLoop object.
*/
extern CFRunLoopRef CFRunLoopGetMain();

/**
    Runs the current thread’s CFRunLoop object in its 
    default mode indefinitely.
*/
extern void CFRunLoopRun();

/**
    Runs the current thread’s CFRunLoop object in a 
    particular mode.
*/
extern CFRunLoopRunResult CFRunLoopRunInMode(CFRunLoopMode mode, CFTimeInterval seconds, bool returnAfterSourceHandled);

/**
    Wakes a waiting CFRunLoop object.
*/
extern void CFRunLoopWakeUp(CFRunLoopRef runloop);

/**
    Forces a CFRunLoop object to stop running.
*/
extern void CFRunLoopStop(CFRunLoopRef runloop);

/**
    Returns a Boolean value that indicates whether the run loop 
    is waiting for an event.
*/
extern bool CFRunLoopIsWaiting(CFRunLoopRef runloop);

/**
    Adds a CFRunLoopSource object to a run loop mode.
*/
extern void CFRunLoopAddSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFRunLoopMode mode);

/**
    Returns a Boolean value that indicates whether a run loop mode 
    contains a particular CFRunLoopSource object.
*/
extern bool CFRunLoopContainsSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFRunLoopMode mode);

/**
    Removes a CFRunLoopSource object from a run loop mode.
*/
extern void CFRunLoopRemoveSource(CFRunLoopRef rl, CFRunLoopSourceRef source, CFRunLoopMode mode);

/**
    Adds a CFRunLoopObserver object to a run loop mode.
*/
extern void CFRunLoopAddObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode);

/**
    Returns a Boolean value that indicates whether a run loop mode 
    contains a particular CFRunLoopObserver object.
*/
extern bool CFRunLoopContainsObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode);

/**
    Removes a CFRunLoopObserver object from a run loop mode.
*/
extern void CFRunLoopRemoveObserver(CFRunLoopRef rl, CFRunLoopObserverRef observer, CFRunLoopMode mode);

/**
    Adds a mode to the set of run loop common modes.
*/
extern void CFRunLoopAddCommonMode(CFRunLoopRef rl, CFRunLoopMode mode);

/**
    Returns an array that contains all the defined modes for a 
    CFRunLoop object.
*/
extern CFArrayRef CFRunLoopCopyAllModes(CFRunLoopRef rl);

/**
    Returns the name of the mode in which a given run loop is currently running.
*/
extern CFRunLoopMode CFRunLoopCopyCurrentMode(CFRunLoopRef rl);

/**
    Adds a CFRunLoopTimer object to a run loop mode.
*/
extern void CFRunLoopAddTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFRunLoopMode mode);

/**
    Returns the time at which the next timer will fire.
*/
extern CFAbsoluteTime CFRunLoopGetNextTimerFireDate(CFRunLoopRef rl, CFRunLoopMode mode);

/**
    Removes a CFRunLoopTimer object from a run loop mode.
*/
extern void CFRunLoopRemoveTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFRunLoopMode mode);

/**
    Returns a Boolean value that indicates whether a run loop mode 
    contains a particular CFRunLoopTimer object.
*/
extern bool CFRunLoopContainsTimer(CFRunLoopRef rl, CFRunLoopTimerRef timer, CFRunLoopMode mode);

/**
    Enqueues a block object on a given runloop to be executed as the 
    runloop cycles in specified modes.
*/
extern void CFRunLoopPerformBlock(CFRunLoopRef rl, CFTypeRef mode, Block!void block);

/**
    Returns the type identifier for the CFRunLoop opaque type.
*/
extern CFTypeID CFRunLoopGetTypeID();

/**
    Objects added to a run loop using this value as the mode are monitored by all run loop 
    modes that have been declared as a member of the set of “common” modes 
    with CFRunLoopAddCommonMode.
*/
extern __gshared const CFRunLoopMode kCFRunLoopCommonModes;

/**
    Run loop mode that should be used when a thread is in its default, or idle, 
    state, waiting for an event. 
    
    This mode is used when the run loop is started with CFRunLoopRun.
*/
extern __gshared const CFRunLoopMode kCFRunLoopDefaultMode;






//
//          CFRunLoopSource
//

/**
    A CFRunLoopSource object is an abstraction of an input source that can be put 
    into a run loop.
*/
alias CFRunLoopSourceRef = CFSubType!("CFRunLoopSource");

/**
    A structure that contains program-defined data and callbacks with which 
    you can configure a version 0 CFRunLoopSource’s behavior.
*/
struct CFRunLoopSourceContext {
extern(C) nothrow @nogc:

    /**
        A cancel callback for the run loop source. 
        This callback is called when the source is removed from a run loop mode.
        
        Can be `null`.
    */
    void function(void* info, CFRunLoopRef rl, CFRunLoopMode mode) cancel;

    /**
        A copy description callback for your program-defined info pointer.
        
        Can be `null`. 
    */
    CFStringRef function(const(void)* info) copyDescription;

    /**
        An equality test callback for your program-defined info pointer.
        
        Can be `null`. 
    */
    bool function(const(void)* info1, const(void)* info2) equal;

    /**
        A hash calculation callback for your program-defined info pointer.
        
        Can be `null`.
    */
    CFHashCode function(const(void)* info) hash;

    /**
        An arbitrary pointer to program-defined data, which can be associated with the 
        CFRunLoopSource at creation time.
        
        This pointer is passed to all the callbacks defined in the context.
    */
    void* info;

    /**
        A perform callback for the run loop source.
        
        This callback is called when the source has fired. 
    */
    void function(void* info) perform;

    /**
        A release callback for your program-defined info pointer.
        
        Can be `null`.
    */
    void function(const(void)* info) release;

    /**
        A release callback for your program-defined info pointer.
        
        Can be `null`.
    */
    const(void)* function(const(void)* info) retain;

    /**
        A release callback for your program-defined info pointer.
        
        Can be `null`.
    */
    void function(void *info, CFRunLoopRef rl, CFRunLoopMode mode) schedule;

    /**
        Version number of the structure.
        
        Must be 0. 
    */
    CFIndex version_ = 0;
}

/**
    Creates a CFRunLoopSource object.
*/
extern CFRunLoopSourceRef CFRunLoopSourceCreate(CFAllocatorRef allocator, CFIndex order, CFRunLoopSourceContext *context);

/**
    Returns the context information for a CFRunLoopSource object.
*/
extern void CFRunLoopSourceGetContext(CFRunLoopSourceRef source, CFRunLoopSourceContext *context);;

/**
    Returns the ordering parameter for a CFRunLoopSource object.
*/
extern CFIndex CFRunLoopSourceGetOrder(CFRunLoopSourceRef source);

/**
    Returns the type identifier of the CFRunLoopSource opaque type.
*/
extern CFTypeID CFRunLoopSourceGetTypeID();

/**
    Invalidates a CFRunLoopSource object, stopping it from ever firing again.
*/
extern void CFRunLoopSourceInvalidate(CFRunLoopSourceRef source);

/**
    Returns a Boolean value that indicates whether a CFRunLoopSource 
    object is valid and able to fire.
*/
extern bool CFRunLoopSourceIsValid(CFRunLoopSourceRef source);

/**
    Signals a CFRunLoopSource object, marking it as ready to fire.
*/
extern void CFRunLoopSourceSignal(CFRunLoopSourceRef source);





//
//          CFRunLoopObserver
//

/**
    A CFRunLoopObserver provides a general means to receive callbacks at different 
    points within a running run loop.
*/
alias CFRunLoopObserverRef = CFSubType!("CFRunLoopObserver");

/**
    Callback invoked when a CFRunLoopObserver object is fired.
*/
alias CFRunLoopObserverCallBack = void function(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info);

/**
    Run loop activity stages in which run loop observers can be scheduled.
*/
enum CFRunLoopActivity : CFOptionFlags {
    kCFRunLoopEntry = (1UL << 0),
    kCFRunLoopBeforeTimers = (1UL << 1),
    kCFRunLoopBeforeSources = (1UL << 2),
    kCFRunLoopBeforeWaiting = (1UL << 5),
    kCFRunLoopAfterWaiting = (1UL << 6),
    kCFRunLoopExit = (1UL << 7),
    kCFRunLoopAllActivities = 0x0FFFFFFFU
}

/**
    A structure that contains program-defined data and callbacks with which you 
    can configure a CFRunLoopObserver object’s behavior.
*/
struct CFRunLoopObserverContext {
extern(C) nothrow @nogc:

    /**
        A copy description callback for your program-defined info pointer.
        
        Can be `null`.
    */
    CFStringRef function(const(void)* info) copyDescription;

    /**
        An arbitrary pointer to program-defined data, which can be associated with the run loop 
        observer at creation time.
        
        This pointer is passed to all the callbacks defined in the context.
    */
    void* info;

    /**
        A release callback for your program-defined info pointer.
        
        Can be `null`.
    */
    void function(const(void)* info) release;

    /**
        A retain callback for your program-defined info pointer.
        
        Can be `null`.
    */
    const(void)* function(const(void)* info) retain;

    /**
        Version number of the structure.
    */
    CFIndex version_ = 0;
}

/**
    Creates a CFRunLoopObserver object with a block-based handler.
*/
extern CFRunLoopObserverRef CFRunLoopObserverCreateWithHandler(CFAllocatorRef allocator, CFOptionFlags activities, bool repeats, 
                                                               CFIndex order, Block!(void, CFRunLoopObserverRef, CFRunLoopActivity) block);

/**
    Creates a CFRunLoopObserver object with a function callback.
*/
extern CFRunLoopObserverRef CFRunLoopObserverCreate(CFAllocatorRef allocator, CFOptionFlags activities, Boolean repeats, 
                                                    CFIndex order, CFRunLoopObserverCallBack callout, CFRunLoopObserverContext *context);

/**
    Returns a Boolean value that indicates whether a CFRunLoopObserver repeats.
*/
extern bool CFRunLoopObserverDoesRepeat(CFRunLoopObserverRef observer);

/**
    Returns the run loop stages during which an observer runs.
*/
extern CFOptionFlags CFRunLoopObserverGetActivities(CFRunLoopObserverRef observer);

/**
    Returns the context information for a CFRunLoopObserver object.
*/
extern void CFRunLoopObserverGetContext(CFRunLoopObserverRef observer, CFRunLoopObserverContext *context);

/**
    Returns the ordering parameter for a CFRunLoopObserver object.
*/
extern CFIndex CFRunLoopObserverGetOrder(CFRunLoopObserverRef observer);

/**
    Returns the type identifier for the CFRunLoopObserver opaque type.
*/
extern CFTypeID CFRunLoopObserverGetTypeID();

/**
    Invalidates a CFRunLoopObserver object, stopping it from ever firing again.
*/
extern void CFRunLoopObserverInvalidate(CFRunLoopObserverRef observer);

/**
    Returns a Boolean value that indicates whether a CFRunLoopObserver 
    object is valid and able to fire.
*/
extern bool CFRunLoopObserverIsValid(CFRunLoopObserverRef observer);






//
//          CFRunLoopTimer
//

/**
    A CFRunLoopTimer object represents a specialized run loop source that fires at a 
    preset time in the future.
*/
alias CFRunLoopTimerRef = CFSubType!("CFRunLoopTimer");

/**
    Callback invoked when a CFRunLoopTimer object fires.
*/
alias CFRunLoopTimerCallBack = void function(CFRunLoopTimerRef timer, void *info);

/**
    A structure that contains program-defined data and callbacks with which you can 
    configure a CFRunLoopTimer’s behavior.
*/
struct CFRunLoopTimerContext {
extern(C) nothrow @nogc:

    /**
        A copy description callback for your program-defined info pointer.
        
        Can be `null`.
    */
    CFStringRef function(const(void)* info) copyDescription;

    /**
        An arbitrary pointer to program-defined data, which can be associated with the run loop 
        observer at creation time.
        
        This pointer is passed to all the callbacks defined in the context.
    */
    void* info;

    /**
        A release callback for your program-defined info pointer.
        
        Can be `null`.
    */
    void function(const(void)* info) release;

    /**
        A retain callback for your program-defined info pointer.
        
        Can be `null`.
    */
    const(void)* function(const(void)* info) retain;

    /**
        Version number of the structure.
    */
    CFIndex version_ = 0;
}

/**
    Creates a new CFRunLoopTimer object with a block-based handler.
*/
extern CFRunLoopTimerRef CFRunLoopTimerCreateWithHandler(CFAllocatorRef allocator, CFAbsoluteTime fireDate, CFTimeInterval interval, 
                                                         CFOptionFlags flags, CFIndex order, Block!(void, CFRunLoopTimerRef) block);

/**
    Creates a new CFRunLoopTimer object with a function callback.
*/
extern CFRunLoopTimerRef CFRunLoopTimerCreate(CFAllocatorRef allocator, CFAbsoluteTime fireDate, CFTimeInterval interval, CFOptionFlags flags, 
                                              CFIndex order, CFRunLoopTimerCallBack callout, CFRunLoopTimerContext *context);

/**
    Returns a Boolean value that indicates whether a CFRunLoopTimer object repeats.
*/
extern bool CFRunLoopTimerDoesRepeat(CFRunLoopTimerRef timer);

/**
    Returns the context information for a CFRunLoopTimer object.
*/
extern void CFRunLoopTimerGetContext(CFRunLoopTimerRef timer, CFRunLoopTimerContext *context);

/**
    Returns the firing interval of a repeating CFRunLoopTimer object.
*/
extern CFTimeInterval CFRunLoopTimerGetInterval(CFRunLoopTimerRef timer);

/**
    Returns the next firing time for a CFRunLoopTimer object.
*/
extern CFAbsoluteTime CFRunLoopTimerGetNextFireDate(CFRunLoopTimerRef timer);

/**
    Returns the ordering parameter for a CFRunLoopTimer object.
*/
extern CFIndex CFRunLoopTimerGetOrder(CFRunLoopTimerRef timer);

/**
    Returns the type identifier of the CFRunLoopTimer opaque type.
*/
extern CFTypeID CFRunLoopTimerGetTypeID();

/**
    Invalidates a CFRunLoopTimer object, stopping it from ever firing again.
*/
extern void CFRunLoopTimerInvalidate(CFRunLoopTimerRef timer);

/**
    Returns a Boolean value that indicates whether a CFRunLoopTimer 
    object is valid and able to fire.
*/
extern bool CFRunLoopTimerIsValid(CFRunLoopTimerRef timer);

/**
    Sets the next firing date for a CFRunLoopTimer object.
*/
extern void CFRunLoopTimerSetNextFireDate(CFRunLoopTimerRef timer, CFAbsoluteTime fireDate);