/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSError
*/
module foundation.nserror;
import foundation;
import objc;

import core.attribute : selector, optional;

/**
    An error domain
*/
alias NSErrorDomain = NSString;

/**
    These keys may exist in the user info dictionary.
*/
alias NSErrorUserInfoKey = NSString;

/**
    Information about an error condition including a domain, a domain-specific 
    error code, and application-specific information.
*/
extern(Objective-C)
extern class NSError : NSObject {
@nogc nothrow:
public:

    /**
        Allocates a new NSString
    */
    override static NSError alloc() @selector("alloc");

    /**
        Returns an initialized NSString object.
    */
    override NSError init() @selector("init");

    /**
        The error code.
    */
    @property NSInteger code() const;

    /**
        A string containing the error domain.
    */
    @property NSErrorDomain code() const;

    /**
        The user info dictionary. 
    */
    @property NSDictionary!(NSErrorUserInfoKey, id) userInfo() const;

    /**
        A string containing the localized description of the error.
    */
    @property NSString localizedDescription() const;

    /**
        Converts to a D string.
    */
    extern(D)
    final string toString() {
        return localizedDescription.toString();
    }
}

extern(C) @nogc nothrow:

/**
    Logs an error message to the Apple System Log facility.
*/
extern void NSLog(NSString format, ...);


/**
    A global variable that determines whether or not the memory 
    of zombie objects is deallocated.
*/
extern __gshared bool NSDeallocateZombies;

/**
    A global variable that can be used to enable debug behavior in your app, 
    such as extra logging.
*/
extern __gshared bool NSDebugEnabled;