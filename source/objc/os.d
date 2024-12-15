/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Helpers for libraries derived from Objective-D
*/
module objc.os;

/// Whether the OS is made by Apple.
version(OSX) enum AppleOS = true;
else version(iOS) enum AppleOS = true;
else version(TVOS) enum AppleOS = true;
else version(WatchOS) enum AppleOS = true;
else version(VisionOS) enum AppleOS = true;
else enum AppleOS = false;

/// Whether the OS is made by Apple for mobile platforms.
version(iOS) enum AppleMobileOS = true;
else version(TVOS) enum AppleMobileOS = true;
else version(WatchOS) enum AppleMobileOS = true;
else version(VisionOS) enum AppleMobileOS = true;
else enum AppleMobileOS = false;

// Intel
version(X86) enum AppleIsIntel = true;
else version(X86_64) enum AppleIsIntel = true;
else enum AppleIsIntel = false;

// ARM
version(ARM) enum AppleIsARM = true;
else version(AArch64) enum AppleIsARM = true;
else enum AppleIsARM = false;

/**
    Mixin template which instructs LDC and other compatible D compilers
    to link against the specified frameworks.
*/
mixin template LinkFramework(frameworks...) {
    
    import objc.os;
    static if(AppleOS) 
        static foreach(framework; frameworks) 
            pragma(linkerDirective, "-framework", framework);
}