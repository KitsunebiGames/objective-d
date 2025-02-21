/**
    NSURL

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.nsurl;
import foundation;
import objc;

import core.attribute : selector, optional;

nothrow @nogc:
version(D_ObjectiveC):

/**
    An object that represents the location of a resource, such as an item on a 
    remote server or the path to a local file. 
*/
extern(Objective-C)
extern class NSURL : NSObject {
@nogc nothrow:
public:

    /**
        Initializes and returns a newly created NSURL object 
        as a file URL with a specified path.
    */
    @property static NSURL fromPath(NSString path) @selector("fileURLWithPath:");

    /**
        Creates and returns an NSURL object initialized with a provided URL string.
    */
    @property static NSURL fromString(NSString str) @selector("URLWithString:");

    /**
        The URL string for the receiver as an absolute URL. (read-only)
    */
    @property NSString absoluteString() const @selector("absoluteString");

    /**
        A string representation of the relative portion of the URL. (read-only)
    */
    @property NSString relativeString() const @selector("relativeString");

    /**
        The base URL. (read-only)
    */
    @property NSURL baseURL() const @selector("baseURL");

    /**
        An absolute URL that refers to the same resource as the receiver. (read-only)
    */
    @property NSURL absoluteURL() const @selector("absoluteURL");

    /**
        The scheme. (read-only)
    */
    @property NSString scheme() const @selector("scheme");

    /**
        The resource specifier. (read-only)
    */
    @property NSString resourceSpecifier() const @selector("resourceSpecifier");

    /**
        The host, conforming to RFC 1808. (read-only)
    */
    @property NSString host() const @selector("host");

    /**
        The port, conforming to RFC 1808.
    */
    @property NSNumber port() const @selector("port");

    /**
        The user name, conforming to RFC 1808.
    */
    @property NSString user() const @selector("user");

    /**
        The password conforming to RFC 1808. (read-only)
    */
    @property NSString password() const @selector("password");

    /**
        The fragment identifier, conforming to RFC 1808. (read-only)
    */
    @property NSString fragment() const @selector("fragment");

    /**
        The query string, conforming to RFC 1808.
    */
    @property NSString query() const @selector("query");

    /**
        The path, conforming to RFC 1808. (read-only)
    */
    @property NSString path() const @selector("path");

    /**
        The relative path, conforming to RFC 1808. (read-only)
    */
    @property NSString relativePath() const @selector("relativePath");

    /**
        An array containing the path components. (read-only)
    */
    @property NSArray!NSString pathComponents() const @selector("pathComponents");

    /**
        The path extension. (read-only)
    */
    @property NSString pathExtension() const @selector("pathExtension");

    /**
        The last path component. (read-only)
    */
    @property bool lastPathComponent() const @selector("lastPathComponent");

    /**
        A C string containing the URL’s file system path. (read-only)
    */
    @property const(char)* fileSystemRepresentation() const @selector("fileSystemRepresentation");

    /**
        A boolean value that determines whether the receiver is a file URL.
    */
    @property bool isFileURL() const @selector("isFileURL");

    /**
        A copy of the URL with any instances of ".." or "." removed from its path. (read-only)
    */
    @property NSURL standardizedURL() const @selector("standardizedURL");

    /**
        Returns whether the URL is a file reference URL.
    */
    @property bool isFileReferenceURL() const @selector("isFileReferenceURL");

    /**
        fileReferenceURL
    */
    @property NSURL fileReferenceURL() const @selector("fileReferenceURL");

    /**
        filePathURL
    */
    @property NSURL filePathURL() const @selector("filePathURL");

    /**
        A Boolean value that indicates whether the URL string’s path represents a directory.
    */
    @property bool hasDirectoryPath() const @selector("hasDirectoryPath");

    /**
        Returns a Boolean value that indicates whether the NSURL instances
        have identical URL strings and base URLs.
    */
    extern(D)
    final bool opEquals(NSURL other) {
        return self.send!bool("isEqual:", other);
    }
}

extern(C) nothrow @nogc:

alias NSURLResourceKey = NSString;

extern const __gshared NSURLResourceKey NSURLNameKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLLocalizedNameKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsRegularFileKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsDirectoryKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsSymbolicLinkKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsVolumeKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsPackageKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsApplicationKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLApplicationIsScriptableKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsSystemImmutableKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsUserImmutableKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsHiddenKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLHasHiddenExtensionKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLCreationDateKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLContentAccessDateKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLContentModificationDateKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLAttributeModificationDateKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLLinkCountKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLParentDirectoryURLKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLVolumeURLKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLTypeIdentifierKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLContentTypeKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLLocalizedTypeDescriptionKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLLabelNumberKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLLabelColorKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLLocalizedLabelKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLEffectiveIconKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLCustomIconKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileResourceIdentifierKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLVolumeIdentifierKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLPreferredIOBlockSizeKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsReadableKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsWritableKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsExecutableKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileSecurityKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsExcludedFromBackupKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLTagNamesKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLCanonicalPathKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsMountTriggerKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLGenerationIdentifierKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLDocumentIdentifierKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLAddedToDirectoryDateKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLQuarantinePropertiesKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileResourceTypeKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileIdentifierKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileContentIdentifierKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLMayShareFileContentKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLMayHaveExtendedAttributesKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsPurgeableKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsSparseKey;  // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileSizeKey; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileAllocatedSizeKey; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLTotalFileSizeKey; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLTotalFileAllocatedSizeKey; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLIsAliasFileKey; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLFileProtectionKey; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLDirectoryEntryCountKey; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLResourceKey NSURLVolumeLocalizedFormatDescriptionKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeTotalCapacityKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeAvailableCapacityKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeResourceCountKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsPersistentIDsKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsSymbolicLinksKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsHardLinksKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsJournalingKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsJournalingKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsSparseFilesKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsZeroRunsKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsCaseSensitiveNamesKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsCasePreservedNamesKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsRootDirectoryDatesKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsVolumeSizesKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsRenamingKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsAdvisoryFileLockingKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsExtendedSecurityKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsBrowsableKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeMaximumFileSizeKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsEjectableKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsRemovableKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsInternalKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsAutomountedKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsLocalKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsReadOnlyKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeCreationDateKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeURLForRemountingKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeUUIDStringKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeNameKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeLocalizedNameKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsEncryptedKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeIsRootFileSystemKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsCompressionKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsFileCloningKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsSwapRenamingKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsExclusiveRenamingKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsImmutableFilesKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsAccessPermissionsKey; // @suppress(dscanner.style.phobos_naming_convention) 
extern const __gshared NSURLResourceKey NSURLVolumeSupportsFileProtectionKey; // @suppress(dscanner.style.phobos_naming_convention) 


alias NSURLFileResourceType = NSString;

extern const __gshared NSURLFileResourceType NSURLFileResourceTypeNamedPipe; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileResourceType NSURLFileResourceTypeCharacterSpecial; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileResourceType NSURLFileResourceTypeDirectory; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileResourceType NSURLFileResourceTypeBlockSpecial; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileResourceType NSURLFileResourceTypeRegular; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileResourceType NSURLFileResourceTypeSymbolicLink; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileResourceType NSURLFileResourceTypeSocket; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileResourceType NSURLFileResourceTypeUnknown; // @suppress(dscanner.style.phobos_naming_convention)

alias NSURLFileProtectionType = NSString;

extern const __gshared NSURLFileProtectionType NSURLFileProtectionNone; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileProtectionType NSURLFileProtectionComplete; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileProtectionType NSURLFileProtectionCompleteUnlessOpen; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileProtectionType NSURLFileProtectionCompleteUntilFirstUserAuthentication; // @suppress(dscanner.style.phobos_naming_convention)
extern const __gshared NSURLFileProtectionType NSURLFileProtectionCompleteWhenUserInactive; // @suppress(dscanner.style.phobos_naming_convention)
