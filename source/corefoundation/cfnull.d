/**
    CoreFoundation Null

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfnull;
import corefoundation.core;

/**
    The CFNull opaque type defines a unique object used to represent null values in collection objects 
    (which don’t allow $(D null) values).

    CFNull objects are neither created nor destroyed, instead a single CFNull constant object $(D kCFNull), 
    is defined and is used wherever a null value is needed.
*/
alias CFNullRef = CFSubType!("CFNull");

/**
    Returns the type identifier for the CFNull opaque type.
*/
extern CFTypeID CFNullGetTypeID();

/**
    A CFNullRef singleton instance.
*/
extern const __gshared CFNullRef kCFNull;