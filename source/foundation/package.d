/**
    Foundation APIs

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation;
import objc;

// Helpers
public import foundation.interop;
public import objc.bridge;
public import objc.block;

// Core Types
public import foundation.core;
public import foundation.nserror;
public import foundation.nsobject;
public import foundation.nsstring;
public import foundation.nsvalue;
public import foundation.nscoder;
public import foundation.nszone;

// Collections
public import foundation.nsenumerator;
public import foundation.nsdictionary;
public import foundation.nsset;
public import foundation.nsarray;

// Other
public import foundation.nsbundle;
public import foundation.nsurl;

// Rebind NSObject in nsproto to NSObjectProtocol.
import nsproto = foundation.nsproto;
alias NSObjectProtocol = nsproto.NSObject;