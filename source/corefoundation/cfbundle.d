/*
    CoreFoundation Bundles

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfbundle;
import corefoundation.cfallocator;
import corefoundation.cfdictionary;
import corefoundation.cfstring;
import corefoundation.cfarray;
import corefoundation.cferror;
import corefoundation.cfurl;
import corefoundation.core;
import foundation.nsbundle;

extern(C) @nogc nothrow:

/**
    A reference to a CFBundle object.
*/
alias CFBundleRef = CFSubType!("CFBundle", NSBundle);
alias CFPlugInRef = CFBundleRef; /// ditto

/**
    Bundle Reference Number
*/
version(LP_64) alias CFBundleRefNum = int;
else alias CFBundleRefNum = SInt16;

enum {
    kCFBundleExecutableArchitectureI386     = 0x00000007,
    kCFBundleExecutableArchitecturePPC      = 0x00000012,
    kCFBundleExecutableArchitectureX86_64   = 0x01000007,
    kCFBundleExecutableArchitecturePPC64    = 0x01000012,
    kCFBundleExecutableArchitectureARM64    = 0x0100000c,
}

/**
    The version of the Info.plist format
*/
extern __gshared const CFStringRef kCFBundleInfoDictionaryVersionKey;

/**
    The name of the executable in this bundle, if any
*/
extern __gshared const CFStringRef kCFBundleExecutableKey;

/**
    The bundle identifier (for CFBundleGetBundleWithIdentifier())
*/
extern __gshared const CFStringRef kCFBundleIdentifierKey;

/**
    The version number of the bundle.  For Mac OS 9 style version numbers (for example "2.5.3d5"),
    clients can use CFBundleGetVersionNumber() instead of accessing this key directly since that
    function will properly convert the version string into its compact integer representation.
*/
extern __gshared const CFStringRef kCFBundleVersionKey;

/**
    The name of the development language of the bundle.
*/
extern __gshared const CFStringRef kCFBundleDevelopmentRegionKey;

/**
    The human-readable name of the bundle.  This key is often found in the InfoPlist.strings since it is usually localized.
*/
extern __gshared const CFStringRef kCFBundleNameKey;

/**
    Allows an unbundled application that handles localization itself to specify which localizations it has available.
*/
extern __gshared const CFStringRef kCFBundleLocalizationsKey;

/**
    Returns the main bundle.

    Returns:
        The main bundle for the current process.
*/
extern CFBundleRef CFBundleGetMainBundle();

/**
    A bundle can name itself by providing a key in the info dictionary.
    This facility is meant to allow bundle-writers to get hold of their
    bundle from their code without having to know where it was on the disk.
    This is meant to be a replacement mechanism for +bundleForClass: users.
    Note that this does not search for bundles on the disk; it will locate
    only bundles already loaded or otherwise known to the current process.
*/
extern CFBundleRef CFBundleGetBundleWithIdentifier(CFStringRef bundleID);

/**
    This is potentially expensive, and not thread-safe.
    Use with care.
    Best used for debuggging or other diagnostic purposes.
*/
extern CFArrayRef CFBundleGetAllBundles();

extern CFTypeID CFBundleGetTypeID();

extern CFBundleRef CFBundleCreate(CFAllocatorRef allocator, CFURLRef bundleURL);
    /* Might return an existing instance with the ref-count bumped. */

extern CFArrayRef CFBundleCreateBundlesFromDirectory(CFAllocatorRef allocator, CFURLRef directoryURL, CFStringRef bundleType);
    /* Create instances for all bundles in the given directory matching the given type */
    /* (or all of them if bundleType is NULL).  Instances are created using CFBundleCreate() and are not released. */

/* ==================== Basic Bundle Info ==================== */

extern CFURLRef CFBundleCopyBundleURL(CFBundleRef bundle);

extern CFTypeRef CFBundleGetValueForInfoDictionaryKey(CFBundleRef bundle, CFStringRef key);
    /* Returns a localized value if available, otherwise the global value. */
    /* This is the recommended function for examining the info dictionary. */

extern CFDictionaryRef CFBundleGetInfoDictionary(CFBundleRef bundle);
    /* This is the global info dictionary.  Note that CFBundle may add */
    /* extra keys to the dictionary for its own use. */

extern CFDictionaryRef CFBundleGetLocalInfoDictionary(CFBundleRef bundle);
    /* This is the localized info dictionary. */

extern void CFBundleGetPackageInfo(CFBundleRef bundle, UInt32 *packageType, UInt32 *packageCreator);

extern CFStringRef CFBundleGetIdentifier(CFBundleRef bundle);

extern UInt32 CFBundleGetVersionNumber(CFBundleRef bundle);

extern CFStringRef CFBundleGetDevelopmentRegion(CFBundleRef bundle);

extern CFURLRef CFBundleCopySupportFilesDirectoryURL(CFBundleRef bundle);

extern CFURLRef CFBundleCopyResourcesDirectoryURL(CFBundleRef bundle);

extern CFURLRef CFBundleCopyPrivateFrameworksURL(CFBundleRef bundle);

extern CFURLRef CFBundleCopySharedFrameworksURL(CFBundleRef bundle);

extern CFURLRef CFBundleCopySharedSupportURL(CFBundleRef bundle);

extern CFURLRef CFBundleCopyBuiltInPlugInsURL(CFBundleRef bundle);

/* ------------- Basic Bundle Info without a CFBundle instance ------------- */
/* This API is provided to enable developers to retrieve basic information */
/* about a bundle without having to create an instance of CFBundle. */
/* Because of caching behavior when a CFBundle instance exists, it will be faster */
/* to actually create a CFBundle if you need to retrieve multiple pieces of info. */
extern CFDictionaryRef CFBundleCopyInfoDictionaryInDirectory(CFURLRef bundleURL);

extern Boolean CFBundleGetPackageInfoInDirectory(CFURLRef url, UInt32 *packageType, UInt32 *packageCreator);

/* ==================== Resource Handling API ==================== */

extern CFURLRef CFBundleCopyResourceURL(CFBundleRef bundle, CFStringRef resourceName, CFStringRef resourceType, CFStringRef subDirName);
extern CFArrayRef CFBundleCopyResourceURLsOfType(CFBundleRef bundle, CFStringRef resourceType, CFStringRef subDirName);
extern CFStringRef CFBundleCopyLocalizedString(CFBundleRef bundle, CFStringRef key, CFStringRef value, CFStringRef tableName);

/**
    Returns a localized string given a list of possible localizations.
    The one most suitable to use with the given $(D bundle) is returned.
    
    Params:
        bundle =        The bundle to examine.
        key:            The key for the localized string to retrieve.
        value:          A default value to return if no value exists for $(D key).
        tableName:      The name of the strings file to search.
        localizations = An array of BCP 47 language codes corresponding to available localizations.
                        Bundle compares the array against its available localizations, and uses the best 
                        result to retrieve the localized string. 
                        If empty, we treat it as no localization is available, and may return a fallback.

    Returns:
        A localized version of the string designated by $(D key) in table $(D tableName).
*/
extern CFStringRef CFBundleCopyLocalizedStringForLocalizations(CFBundleRef bundle, CFStringRef key, CFStringRef value, CFStringRef tableName, CFArrayRef localizations);

extern CFURLRef CFBundleCopyResourceURLInDirectory(CFURLRef bundleURL, CFStringRef resourceName, CFStringRef resourceType, CFStringRef subDirName);
extern CFArrayRef CFBundleCopyResourceURLsOfTypeInDirectory(CFURLRef bundleURL, CFStringRef resourceType, CFStringRef subDirName);

/**
    Lists the localizations that a bundle contains.
*/
extern CFArrayRef CFBundleCopyBundleLocalizations(CFBundleRef bundle);

/**
    Get localizations from an array.

    Given an array of possible localizations, returns the one or more
    of them that CFBundle would use in the current application context.
    To determine the localizations that would be used for a particular
    bundle in the current application context, apply this function to the
    result of CFBundleCopyBundleLocalizations().
*/
extern CFArrayRef CFBundleCopyPreferredLocalizationsFromArray(CFArrayRef locArray);

/**
    Given an array of possible localizations, returns the one or more of
    them that CFBundle would use, without reference to the current application
    context, if the user's preferred localizations were given by prefArray.
    If prefArray is NULL, the current user's actual preferred localizations will
    be used. This is not the same as CFBundleCopyPreferredLocalizationsFromArray(),
    because that function takes the current application context into account.
    To determine the localizations that another application would use, apply
    this function to the result of CFBundleCopyBundleLocalizations().
*/
extern CFArrayRef CFBundleCopyLocalizationsForPreferences(CFArrayRef locArray, CFArrayRef prefArray);
extern CFURLRef CFBundleCopyResourceURLForLocalization(CFBundleRef bundle, CFStringRef resourceName, CFStringRef resourceType, CFStringRef subDirName, CFStringRef localizationName);

/**
    The localizationName argument to CFBundleCopyResourceURLForLocalization() or
    CFBundleCopyResourceURLsOfTypeForLocalization() must be identical to one of the
    localizations in the bundle, as returned by CFBundleCopyBundleLocalizations().
    It is recommended that either CFBundleCopyPreferredLocalizationsFromArray() or
    CFBundleCopyLocalizationsForPreferences() be used to select the localization.
*/
extern CFArrayRef CFBundleCopyResourceURLsOfTypeForLocalization(CFBundleRef bundle, CFStringRef resourceType, CFStringRef subDirName, CFStringRef localizationName);

/**
    For a directory URL, this is equivalent to CFBundleCopyInfoDictionaryInDirectory().
    For a plain file URL representing an unbundled executable, this will attempt to read
    an info dictionary from the (__TEXT, __info_plist) section, if it is a Mach-o file.
*/
extern CFDictionaryRef CFBundleCopyInfoDictionaryForURL(CFURLRef url);

/**
    For a directory URL, this is equivalent to calling CFBundleCopyBundleLocalizations()
    on the corresponding bundle.  For a plain file URL representing an unbundled executable,
    this will attempt to determine its localizations using the CFBundleLocalizations and
    CFBundleDevelopmentRegion keys in the dictionary returned by CFBundleCopyInfoDictionaryForURL.
*/
extern CFArrayRef CFBundleCopyLocalizationsForURL(CFURLRef url);

/**
    For a directory URL, this is equivalent to calling CFBundleCopyExecutableArchitectures()
    on the corresponding bundle.  For a plain file URL representing an unbundled executable,
    this will return the architectures it provides, if it is a Mach-o file, or NULL otherwise.
*/
extern CFArrayRef CFBundleCopyExecutableArchitecturesForURL(CFURLRef url);
extern CFURLRef CFBundleCopyExecutableURL(CFBundleRef bundle);

/**
    If the bundle's executable exists and is a Mach-o file, this function will return an array
    of CFNumbers whose values are integers representing the architectures the file provides.
    The values currently in use are those listed in the enum above, but others may be added
    in the future.  If the executable is not a Mach-o file, this function returns NULL. 
*/
extern CFArrayRef CFBundleCopyExecutableArchitectures(CFBundleRef bundle);

/**
    This function will return true if the bundle is loaded, or if the bundle appears to be
    loadable upon inspection.  This does not mean that the bundle is definitively loadable,
    since it may fail to load due to link errors or other problems not readily detectable.
    If this function detects problems, it will return false, and return a CFError by reference.
    It is the responsibility of the caller to release the CFError.
*/
extern Boolean CFBundlePreflightExecutable(CFBundleRef bundle, CFErrorRef *error);

/**
    If the bundle is already loaded, this function will return true.  Otherwise, it will attempt
    to load the bundle, and it will return true if that attempt succeeds.  If the bundle fails
    to load, this function will return false, and it will return a CFError by reference.
    It is the responsibility of the caller to release the CFError.
*/
extern Boolean CFBundleLoadExecutableAndReturnError(CFBundleRef bundle, CFErrorRef *error);

extern Boolean CFBundleLoadExecutable(CFBundleRef bundle);
extern Boolean CFBundleIsExecutableLoaded(CFBundleRef bundle);
extern void CFBundleUnloadExecutable(CFBundleRef bundle);
extern void *CFBundleGetFunctionPointerForName(CFBundleRef bundle, CFStringRef functionName);
extern void CFBundleGetFunctionPointersForNames(CFBundleRef bundle, CFArrayRef functionNames, void** ftbl);
extern void *CFBundleGetDataPointerForName(CFBundleRef bundle, CFStringRef symbolName);
extern void CFBundleGetDataPointersForNames(CFBundleRef bundle, CFArrayRef symbolNames, void** stbl);

/**
    This function can be used to find executables other than your main
    executable.  This is useful, for instance, for applications that have
    some command line tool that is packaged with and used by the application.
    The tool can be packaged in the various platform executable directories
    in the bundle and can be located with this function.  This allows an
    app to ship versions of the tool for each platform as it does for the
    main app executable.
*/
extern CFURLRef CFBundleCopyAuxiliaryExecutableURL(CFBundleRef bundle, CFStringRef executableName);
extern CFPlugInRef CFBundleGetPlugIn(CFBundleRef bundle);

version(OSX) {
    extern Boolean CFBundleIsExecutableLoadable(CFBundleRef bundle);
    extern Boolean CFBundleIsExecutableLoadableForURL(CFURLRef url);
    // extern Boolean CFBundleIsArchitectureLoadable(cpu_type_t arch);

    /**
        This function opens the non-localized and the localized resource files
        (if any) for the bundle, creates and makes current a single read-only
        resource map combining both, and returns a reference number for it.
        If it is called multiple times, it opens the files multiple times,
        and returns distinct reference numbers.
    */
    deprecated("The Carbon Resource Manager is deprecated. This should only be used to access Resource Manager-style resources in old bundles.")
    extern CFBundleRefNum CFBundleOpenBundleResourceMap(CFBundleRef bundle);
    
    /**
        Similar to CFBundleOpenBundleResourceMap(), except that it creates two
        separate resource maps and returns reference numbers for both.
    */
    deprecated("The Carbon Resource Manager is deprecated. This should only be used to access Resource Manager-style resources in old bundles.")
    extern SInt32 CFBundleOpenBundleResourceFiles(CFBundleRef bundle, CFBundleRefNum *refNum, CFBundleRefNum *localizedRefNum);

    deprecated("The Carbon Resource Manager is deprecated. This should only be used to access Resource Manager-style resources in old bundles.")
    extern void CFBundleCloseBundleResourceMap(CFBundleRef bundle, CFBundleRefNum refNum);
}