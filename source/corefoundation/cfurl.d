/**
    CoreFoundation Strings

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfurl;
import corefoundation.core;
import foundation.nsurl;

/**
    The CFURL opaque type provides facilities for creating, parsing, and dereferencing URL strings. 
    CFURL is useful to applications that need to use URLs to access resources, including local files.
*/
alias CFURLRef = CFSubType!("CFURL", NSURL);