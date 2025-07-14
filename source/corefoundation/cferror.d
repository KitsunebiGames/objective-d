/**
    CoreFoundation Errors

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cferror;
import corefoundation.cfallocator;
import corefoundation.cfstring;
import corefoundation.cfdictionary;
import corefoundation.core;
import foundation.nserror;

extern(C) @nogc nothrow:

/**
    A reference to a CFError object.
*/
alias CFErrorRef = CFSubType!("CFError", NSError);

/**
    Creates a new CFError object.
*/
extern CFErrorRef CFErrorCreate(CFAllocatorRef allocator, CFErrorDomain domain, CFIndex code, CFDictionaryRef userInfo);

/**
    Creates a new CFError object using given keys and values to create the user info dictionary.
*/
extern CFErrorRef CFErrorCreateWithUserInfoKeysAndValues(CFAllocatorRef allocator, CFErrorDomain domain, CFIndex code, const(const(void)*)* userInfoKeys, const(const(void)*)* userInfoValues, CFIndex numUserInfoValues);

/**
    Returns the error domain for a given CFError.
*/
extern CFErrorDomain CFErrorGetDomain(CFErrorRef err);

/**
    Returns the error code for a given CFError.
*/
extern CFIndex CFErrorGetCode(CFErrorRef err);

/**
    Returns the user info dictionary for a given CFError.
*/
extern CFDictionaryRef CFErrorCopyUserInfo(CFErrorRef err);

/**
    Returns a human-presentable description for a given error.
*/
extern CFStringRef CFErrorCopyDescription(CFErrorRef err);

/**
    Returns a human-presentable failure reason for a given error.
*/
extern CFStringRef CFErrorCopyFailureReason(CFErrorRef err);

/**
    Returns a human presentable recovery suggestion for a given error.
*/
extern CFStringRef CFErrorCopyRecoverySuggestion(CFErrorRef err);

/**
    Returns the type identifier for the CFError opaque type.
*/
extern CFTypeID CFErrorGetTypeID();

/**
    Error Domain
*/
alias CFErrorDomain = CFStringRef;

/**
    A constant that specified the POSIX domain.
*/
extern __gshared const CFErrorDomain kCFErrorDomainPOSIX;

/**
    A constant that specified the OS domain.
*/
extern __gshared const CFErrorDomain kCFErrorDomainOSStatus;

/**
    A constant that specified the Mach domain.
*/
extern __gshared const CFErrorDomain kCFErrorDomainMach;

/**
    A constant that specified the Cocoa domain.
*/
extern __gshared const CFErrorDomain kCFErrorDomainCocoa;

/**
    Key to identify the user-presentable description in the userInfo dictionary.
*/
extern __gshared const CFStringRef kCFErrorLocalizedDescriptionKey;

/**
    Key to identify the user-presentable failure reason in the userInfo dictionary.
*/
extern __gshared const CFStringRef kCFErrorLocalizedFailureReasonKey;

/**
    Key to identify the user-presentable recovery suggestion in the userInfo dictionary.
*/
extern __gshared const CFStringRef kCFErrorLocalizedRecoverySuggestionKey;

/**
    Key to identify the description in the userInfo dictionary.
*/
extern __gshared const CFStringRef kCFErrorDescriptionKey;

/**
    Key to identify the underlying error in the userInfo dictionary.
*/
extern __gshared const CFStringRef kCFErrorUnderlyingErrorKey;

/**
    Key to identify associated URL in the userInfo dictionary.
*/
extern __gshared const CFStringRef kCFErrorURLKey;

/**
    Key to identify associated file path in the userInfo dictionary.
*/
extern __gshared const CFStringRef kCFErrorFilePathKey;