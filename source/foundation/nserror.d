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
    Error codes in the Cocoa error domain.
*/
alias NSErrorCode = NSInteger;

/**
    Information about an error condition including a domain, a domain-specific 
    error code, and application-specific information.
*/
extern(Objective-C)
extern class NSError : NSObject {
@nogc nothrow:
public:

    /**
        Allocates a new NSError
    */
    override static NSError alloc() @selector("alloc");

    /**
        Returns an initialized NSError object.
    */
    override NSError init() @selector("init");

    /**
        The error code.
    */
    @property NSErrorCode code() const;

    /**
        A string containing the error domain.
    */
    @property NSErrorDomain domain() const;

    /**
        The user info dictionary. 
    */
    @property NSDictionary!(NSErrorUserInfoKey, id) userInfo() const;

    /**
        A string containing the localized description of the error.
    */
    @property NSString localizedDescription() const;

    /**
        An array containing the localized titles of buttons appropriate for displaying in an alert panel.
    */
    @property NSArray!NSString localizedRecoveryOptions() const;

    /**
       A string containing the localized recovery suggestion for the error.
    */
    @property NSString localizedRecoverySuggestion() const;

    /**
        A string containing the localized explanation of the reason for the error.
    */
    @property NSString localizedFailureReason() const;

    /**
        A string to display in response to an alert panel help anchor button being pressed.
    */
    @property NSString helpAnchor() const;

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
    Cocoa errors
*/
extern __gshared const NSErrorDomain NSCocoaErrorDomain;

/**
    POSIX/BSD errors
*/
extern __gshared const NSErrorDomain NSPOSIXErrorDomain;

/**
    Mac OS 9/Carbon errors
*/
extern __gshared const NSErrorDomain NSOSStatusErrorDomain;

/**
    Mach errors
*/
extern __gshared const NSErrorDomain NSMachErrorDomain;

/**
    URL loading system errors
*/
extern __gshared const NSErrorDomain NSURLErrorDomain;

/**
    The error domain used by NSError when reporting SOCKS errors.
*/
extern __gshared const NSErrorDomain NSStreamSOCKSErrorDomain;

/**
    The error domain used by NSError when reporting SSL errors.
*/
extern __gshared const NSErrorDomain NSStreamSocketSSLErrorDomain;

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