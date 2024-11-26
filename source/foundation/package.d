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

public import foundation.collections;
public import foundation.nsstring;
public import foundation.nsvalue;
public import foundation.nserror;
public import foundation.nscoder;
public import foundation.nszone;
public import foundation.nsbundle;
public import foundation.nsurl;
public import foundation.nsobject;

import nsproto = foundation.nsproto;

alias NSObjectProtocol = nsproto.NSObject;