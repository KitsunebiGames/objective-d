/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSBundle
*/
module foundation.nsbundle;
import foundation;
import objc;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

/**
    Constants that describe the CPU types that a bundle’s executable code supports.
*/
enum NSBundleExecutableArchitecture {
    
    /**
        The 32-bit Intel architecture.
    */
    I386      = 0x00000007,
    
    /**
        The 32-bit PowerPC architecture.
    */
    PPC       = 0x00000012,
    
    /**
        The 64-bit Intel architecture.
    */
    X86_64    = 0x01000007,
    
    /**
        The 64-bit PowerPC architecture.
    */
    PPC64     = 0x01000012,
    
    /**
        The 64-bit ARM architecture.
    */
    ARM64     = 0x0100000c
}

/**
    A representation of the code and resources stored in a bundle directory on disk. 
*/
extern(Objective-C)
extern class NSBundle : NSObject {
private:
@nogc nothrow:
public:

    /**
        Returns the bundle object that contains the current executable.
    */
    @property static NSBundle mainBundle() @selector("mainBundle");

    /**
        Returns an array of all of the application’s bundles that represent frameworks.
    */
    @property static NSArray!NSBundle allFrameworks() @selector("allFrameworks");

    /**
        Returns an array of all the application’s non-framework bundles.
    */
    @property static NSArray!NSBundle allBundles() @selector("allBundles");

    /**
        Returns an NSBundle object that corresponds to the specified file URL.
    */
    @property static NSBundle fromURL(NSURL url) @selector("bundleWithURL:");

    /**
        Returns an NSBundle object that corresponds to the specified file path.
    */
    @property static NSBundle fromPath(NSString url) @selector("bundleWithPath:");

    /**
        The load status of a bundle.
    */
    @property bool loaded() const @selector("loaded");

    /**
        A dictionary, constructed from the bundle’s Info.plist file, that contains information about the receiver.
    */
    @property NSDictionary!(NSString, id) info() const @selector("infoDictionary");

    /**
        The full URL of the receiver’s bundle directory.
    */
    @property NSURL bundleURL() const @selector("bundleURL");

    /**
        The file URL of the bundle’s subdirectory containing resource files.
    */
    @property NSURL resourceURL() const @selector("resourceURL");

    /**
        The file URL of the receiver's executable file.
    */
    @property NSURL executableURL() const @selector("executableURL");

    /**
        The file URL of the bundle’s subdirectory containing private frameworks.
    */
    @property NSURL privateFrameworksURL() const @selector("privateFrameworksURL");

    /**
        The file URL of the receiver's subdirectory containing shared frameworks.
    */
    @property NSURL sharedFrameworksURL() const @selector("executableURL");

    /**
        The file URL of the receiver's subdirectory containing plug-ins.
    */
    @property NSURL builtInPlugInsURL() const @selector("builtInPlugInsURL");

    /**
        The file URL of the bundle’s subdirectory containing shared support files.
    */
    @property NSURL sharedSupportURL() const @selector("sharedSupportURL");

    /**
        The file URL for the bundle’s App Store receipt.
    */
    @property NSURL appStoreReceiptURL() const @selector("appStoreReceiptURL");

    /**
        The full pathname of the receiver’s bundle directory.
    */
    @property NSString bundlePath() const @selector("bundlePath");

    /**
        The full pathname of the bundle’s subdirectory containing resources.
    */
    @property NSString resourcePath() const @selector("resourcePath");

    /**
        The full pathname of the receiver's executable file.
    */
    @property NSString executablePath() const @selector("executablePath");

    /**
        The full pathname of the bundle’s subdirectory containing private frameworks.
    */
    @property NSString privateFrameworksPath() const @selector("privateFrameworksPath");

    /**
        The full pathname of the bundle’s subdirectory containing shared frameworks.
    */
    @property NSString sharedFrameworksPath() const @selector("sharedFrameworksPath");

    /**
        The full pathname of the bundle’s subdirectory containing shared support files.
    */
    @property NSString sharedSupportPath() const @selector("sharedSupportPath");

    /**
        The full pathname of the receiver's subdirectory containing plug-ins.
    */
    @property NSString builtInPlugInsPath() const @selector("builtInPlugInsPath");

    /**
        The receiver’s bundle identifier.
    */
    @property NSString bundleIdentifier() const @selector("bundleIdentifier");

    /**
        An array of numbers indicating the architecture types supported by the bundle’s executable.
    */
    @property NSArray!NSNumber executableArchitectures() const @selector("executableArchitectures");

    /**
        The bundle’s principal class.
    */
    @property Class principalClass() const;

    /**
        Dynamically loads the bundle’s executable code into a running program, 
        if the code has not already been loaded.
    */
    bool load() @selector("load");

    /**
        Unloads the code associated with the receiver. 
    */
    bool unload() @selector("unload");

    /**
        Returns the Class object for the specified name.
    */
    Class getClass(NSString name) @selector("classNamed:");
}

extern(C) nothrow @nogc:

/**
    A constant used as a key for the userInfo dictionary of a NSBundleDidLoadNotification notification that 
    corresponds to an array of names of each class that was loaded.
*/
extern __gshared const NSString NSLoadedClasses;