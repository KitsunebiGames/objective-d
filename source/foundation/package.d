/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to Apple's Foundation API.
*/
module foundation;
import objc;

// Core Types
public import foundation.nserror;
public import foundation.nsobject;
public import foundation.nscoder;
public import foundation.nszone;

// Collections
public import foundation.nsenumerator;
public import foundation.nsdictionary;
public import foundation.nsset;
public import foundation.nsarray;

// Text Handling
public import foundation.nsstring;

// Other
public import foundation.nsvalue;
public import foundation.nsbundle;
public import foundation.nsurl;

// Rebind NSObject in nsproto to NSObjectProtocol.
import nsproto = foundation.nsproto;
alias NSObjectProtocol = nsproto.NSObject;