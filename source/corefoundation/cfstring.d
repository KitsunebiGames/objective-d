/**
    CoreFoundation Strings

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfstring;
import corefoundation.cfallocator;
import corefoundation.cfdictionary;
import corefoundation.cfdata;
import corefoundation.cflocale;
import corefoundation.cfarray;
import corefoundation.cfcharset;
import corefoundation.core;
import foundation.nsstring;

extern(C) @nogc nothrow:

/**
    A CoreFoundation String
*/
alias CFStringRef = CFSubType!("CFString", NSString);

/**
    A CoreFoundation Mutable String
*/
alias CFMutableStringRef = CFSubType!("CFMutableString", NSMutableString);

/**
    An integer type for constants used to specify supported 
    string encodings in various CFString functions.
*/
alias CFStringEncoding = uint;

/**
    Platform-independent built-in encodings; always available on all platforms.

    Call CFStringGetSystemEncoding() to get the default system encoding.
*/
enum CFStringBuiltInEncodings : CFStringEncoding {
    
    /**
        Represents an encoding which is not supported.
    */
    Invalid = 0xffffffffU,
    
    /**
        Basic Mac encoding for roman (latin) characters.
    */
    MacRoman = 0,
    
    /**
        ANSI codepage 1252
    */
    WindowsLatin1 = 0x0500, /*  */
    
    /**
        ISO 8859-1
    */
    ISOLatin1 = 0x0201, /*  */
    
    /**
        NextStep encoding
    */
    NextStepLatin = 0x0B01, /* */
    
    /**
        7-bit ASCII Encoding

        Values greater than 0x7F are treated as corresponding Unicode value.
    */
    ASCII = 0x0600, /*  */
    
    /**
        Unicode text encoding
    */
    Unicode = 0x0100,
    
    /**
        UTF-8
    */
    UTF8 = 0x08000100,
    
    /**
        7-bit Unicode variants used by Cocoa & Java
    */
    NonLossyASCII = 0x0BFF,
    
    /**
        UTF-16
    */
    UTF16 = 0x0100,
    
    /**
        UTF-16 (Big-endian)
    */
    UTF16BE = 0x10000100,
    
    /**
        UTF-16 (Little-endian)
    */
    UTF16LE = 0x14000100,
    
    /**
        UTF-32
    */
    UTF32 = 0x0c000100,
    
    /**
        UTF-32 (Big-endian)
    */
    UTF32BE = 0x18000100,
    
    /**
        UTF-32 (Little-endian)
    */
    UTF32LE = 0x1c000100,
}

/**
    Gets the type ID of CFString
*/
extern CFTypeID CFStringGetTypeID();

/**
    The following four functions copy the provided buffer into CFString's internal storage.
*/
extern CFStringRef CFStringCreateWithPascalString(CFAllocatorRef alloc, ConstStr255Param pStr, CFStringEncoding encoding);
extern CFStringRef CFStringCreateWithCString(CFAllocatorRef alloc, const(char)* cStr, CFStringEncoding encoding);

/**
    The following takes an explicit length, and allows you to specify whether the data is an external format --
    that is, whether to pay attention to the BOM character (if any) and do byte swapping if necessary
*/
extern CFStringRef CFStringCreateWithBytes(CFAllocatorRef alloc, const UInt8 *bytes, CFIndex numBytes, CFStringEncoding encoding, bool isExternalRepresentation);
extern CFStringRef CFStringCreateWithCharacters(CFAllocatorRef alloc, const(UniChar)* chars, CFIndex numChars);
extern CFStringRef CFStringCreateWithCharactersNoCopy(CFAllocatorRef alloc, const(UniChar)* chars, CFIndex numChars, CFAllocatorRef contentsDeallocator);

/**
    Create copies of part or all of the string.
*/
extern CFStringRef CFStringCreateWithSubstring(CFAllocatorRef alloc, CFStringRef str, CFRange range);
extern CFStringRef CFStringCreateCopy(CFAllocatorRef alloc, CFStringRef theString);

/**
    These functions create a CFString from the provided printf-like format string and arguments.
*/
extern CFStringRef CFStringCreateWithFormat(CFAllocatorRef alloc, CFDictionaryRef formatOptions, CFStringRef format, ...);

/**
    Functions to create mutable strings. "maxLength", if not 0, is a hard bound on the length of the string.
    
    If 0, there is no limit on the length.
*/
extern CFMutableStringRef CFStringCreateMutable(CFAllocatorRef alloc, CFIndex maxLength);
extern CFMutableStringRef CFStringCreateMutableCopy(CFAllocatorRef alloc, CFIndex maxLength, CFStringRef theString);

/**
    This function creates a mutable string that has a developer supplied and directly editable backing store.
    The string will be manipulated within the provided buffer (if any) until it outgrows capacity; then the
    externalCharactersAllocator will be consulted for more memory. When the CFString is deallocated, the
    buffer will be freed with the externalCharactersAllocator. Provide kCFAllocatorNull here to prevent the buffer
    from ever being reallocated or deallocated by CFString. See comments at top of this file for more info.
*/
extern CFMutableStringRef CFStringCreateMutableWithExternalCharactersNoCopy(CFAllocatorRef alloc, UniChar *chars, CFIndex numChars, CFIndex capacity, CFAllocatorRef externalCharactersAllocator);


/**
    Number of 16-bit Unicode characters in the string.
*/
extern CFIndex CFStringGetLength(CFStringRef theString);

/**
    Extracting the contents of the string. For obtaining multiple characters, calling
    CFStringGetCharacters() is more efficient than multiple calls to CFStringGetCharacterAtIndex().
    If the length of the string is not known (so you can't use a fixed size buffer for CFStringGetCharacters()),
    another method is to use is CFStringGetCharacterFromInlineBuffer() (see further below).
*/
extern UniChar CFStringGetCharacterAtIndex(CFStringRef theString, CFIndex idx);
extern void CFStringGetCharacters(CFStringRef theString, CFRange range, UniChar *buffer);

/**
    These two convert into the provided buffer; they return false if conversion isn't possible
    (due to conversion error, or not enough space in the provided buffer). 
    These functions do zero-terminate or put the length byte; the provided bufferSize should include
    space for this (so pass 256 for Str255). More sophisticated usages can go through CFStringGetBytes().
    These functions are equivalent to calling CFStringGetBytes() with 
    the range of the string; lossByte = 0; and isExternalRepresentation = false; 
    if successful, they then insert the leading length or terminating zero, as desired.
*/
extern bool CFStringGetCString(CFStringRef theString, char *buffer, CFIndex bufferSize, CFStringEncoding encoding);

/**
    These functions attempt to return in O(1) time the desired format for the string.
    Note that although this means a pointer to the internal structure is being returned,
    this can't always be counted on. Please see note at the top of the file for more
    details.

    May return NULL at any time; be prepared for NULL
*/
extern const(char)* CFStringGetCStringPtr(CFStringRef theString, CFStringEncoding encoding);
extern const(UniChar)* CFStringGetCharactersPtr(CFStringRef theString);

/* 
    The primitive conversion routine; allows you to convert a string piece at a time
        into a fixed size buffer. Returns number of characters converted. 
    Characters that cannot be converted to the specified encoding are represented
        with the byte specified by lossByte; if lossByte is 0, then lossy conversion
        is not allowed and conversion stops, returning partial results.
    Pass buffer==NULL if you don't care about the converted string (but just the convertability,
        or number of bytes required). 
    maxBufLength indicates the maximum number of bytes to generate. It is ignored when buffer==NULL.
    Does not zero-terminate. If you want to create Pascal or C string, allow one extra byte at start or end. 
    Setting isExternalRepresentation causes any extra bytes that would allow 
        the data to be made persistent to be included; for instance, the Unicode BOM. Note that
        CFString prepends UTF encoded data with the Unicode BOM <http://www.unicode.org/faq/utf_bom.html> 
        when generating external representation if the target encoding allows. It's important to note that
        only UTF-8, UTF-16, and UTF-32 define the handling of the byte order mark character, and the "LE"
        and "BE" variants of UTF-16 and UTF-32 don't.
*/
extern CFIndex CFStringGetBytes(CFStringRef theString, CFRange range, CFStringEncoding encoding, UInt8 lossByte, bool isExternalRepresentation, UInt8 *buffer, CFIndex maxBufLen, CFIndex *usedBufLen);

/*
    Convenience functions String <-> Data. These generate "external" formats, that is, formats that
    can be written out to disk. For instance, if the encoding is Unicode,
    CFStringCreateFromExternalRepresentation() pays attention to the BOM character (if any) 
    and does byte swapping if necessary. Similarly CFStringCreateExternalRepresentation() will  
    include a BOM character if appropriate. See CFStringGetBytes() for more on this and lossByte.

    May return NULL on conversion error
*/
extern CFStringRef CFStringCreateFromExternalRepresentation(CFAllocatorRef alloc, CFDataRef data, CFStringEncoding encoding);
extern CFDataRef CFStringCreateExternalRepresentation(CFAllocatorRef alloc, CFStringRef theString, CFStringEncoding encoding, UInt8 lossByte);

/**
    Hints about the contents of a string

    Result in O(n) time max
*/
extern CFStringEncoding CFStringGetSmallestEncoding(CFStringRef theString);
extern CFStringEncoding CFStringGetFastestEncoding(CFStringRef theString);

/**
    General encoding info

    The default encoding for the system; untagged 8-bit characters are usually in this encoding.
*/
extern CFStringEncoding CFStringGetSystemEncoding();
extern CFIndex CFStringGetMaximumSizeForEncoding(CFIndex length, CFStringEncoding encoding);

/**
    Extract the contents of the string as a NULL-terminated 8-bit string appropriate for passing to POSIX APIs (for example, normalized for HFS+).
    The string is zero-terminated. false will be returned if the conversion results don't fit into the buffer.
    
    Use CFStringGetMaximumSizeOfFileSystemRepresentation() if you want to make sure the buffer is of sufficient length.
*/
extern bool CFStringGetFileSystemRepresentation(CFStringRef string, char *buffer, CFIndex maxBufLen);

/**
    Get the upper bound on the number of bytes required to hold the file system representation for the string.
    This result is returned quickly as a very rough approximation, and could be much larger than the actual space required.
    The result includes space for the zero termination. If you are allocating a buffer for long-term keeping, 
    it's recommended that you reallocate it smaller (to be the right size) after calling CFStringGetFileSystemRepresentation(). 
*/
extern CFIndex CFStringGetMaximumSizeOfFileSystemRepresentation(CFStringRef string);

/**
    Create a CFString from the specified zero-terminated POSIX file system representation.
    If the conversion fails (possible due to bytes in the buffer not being a valid sequence of bytes for the 
    appropriate character encoding), NULL is returned.
*/
extern CFStringRef CFStringCreateWithFileSystemRepresentation(CFAllocatorRef alloc, const(char)* buffer);

/**
    Find and compare flags; these are OR'ed together and provided as CFStringCompareFlags in the various functions. 
*/
enum CFStringCompareFlags : CFOptionFlags {
    
    /**
        Comparison is case insensitive
    */
    CaseInsensitive = 1,	
    
    /**
        Starting from the end of the string.
    */
    Backwards = 4,		/*  */
    
    /**
        Only at the specified starting point.
    */
    Anchored = 8,		/*  */
    
    /**
        If specified, loose equivalence is performed (o-umlaut == o, umlaut).
    */
    Nonliteral = 16,		/*  */
    
    /**
        User's default locale is used for the comparisons.
    */
    Localized = 32,		/*  */
    
    /**
        Numeric comparison is used; that is, Foo2.txt < Foo7.txt < Foo25.txt.
    */
    Numerically = 64,		/*  */
    
    /**
        If specified, ignores diacritics (o-umlaut == o).
    */
    DiacriticInsensitive = 128, /*  */
    
    /**
        If specified, ignores width differences ('a' == UFF41).
    */
    WidthInsensitive = 256, /*  */
    
    /**
        If specified, comparisons are forced to return either 
            CFCompare.LessThan or CFCompare.GreaterThan
        if the strings are equivalent but not strictly equal, for stability when 
        sorting (e.g. "aaa" > "AAA" with CFCompare.CaseInsensitive specified)
    */
    ForcedOrdering = 512 /*  */
}

/**
    The main comparison routine; compares specified range of the first string to (the full range of) the second string.
        locale == NULL indicates canonical locale (the return value from CFLocaleGetSystem()).
        kCFCompareNumerically, added in 10.2, does not work if kCFCompareLocalized is specified on systems before 10.3
        kCFCompareBackwards and kCFCompareAnchored are not applicable.
        rangeToCompare applies to the first string; that is, only the substring of theString1 specified by rangeToCompare is compared against all of theString2.
*/
extern CFComparisonResult CFStringCompareWithOptionsAndLocale(CFStringRef theString1, CFStringRef theString2, CFRange rangeToCompare, CFStringCompareFlags compareOptions, CFLocaleRef locale);

/**
    Comparison convenience. Uses the current user locale (the return value from CFLocaleCopyCurrent()) if kCFCompareLocalized. Refer to CFStringCompareWithOptionsAndLocale() for more info.
*/
extern CFComparisonResult CFStringCompareWithOptions(CFStringRef theString1, CFStringRef theString2, CFRange rangeToCompare, CFStringCompareFlags compareOptions);

/**
    Comparison convenience suitable for passing as sorting functions.
        kCFCompareNumerically, added in 10.2, does not work if kCFCompareLocalized is specified on systems before 10.3
        kCFCompareBackwards and kCFCompareAnchored are not applicable.
*/
extern CFComparisonResult CFStringCompare(CFStringRef theString1, CFStringRef theString2, CFStringCompareFlags compareOptions);

/**
    CFStringFindWithOptionsAndLocale() returns the found range in the CFRange * argument; you can pass NULL for simple discovery check.
        locale == NULL indicates canonical locale (the return value from CFLocaleGetSystem()).
        If stringToFind is the empty string (zero length), nothing is found.
        Ignores the kCFCompareNumerically option.
        Only the substring of theString specified by rangeToSearch is searched for stringToFind.
*/
extern bool CFStringFindWithOptionsAndLocale(CFStringRef theString, CFStringRef stringToFind, CFRange rangeToSearch, CFStringCompareFlags searchOptions, CFLocaleRef locale, CFRange *result);

/**
    Find convenience. Uses the current user locale (the return value from CFLocaleCopyCurrent()) if kCFCompareLocalized. Refer to CFStringFindWithOptionsAndLocale() for more info.
*/
extern bool CFStringFindWithOptions(CFStringRef theString, CFStringRef stringToFind, CFRange rangeToSearch, CFStringCompareFlags searchOptions, CFRange *result);

/**
    CFStringCreateArrayWithFindResults() returns an array of CFRange pointers, or NULL if there are no matches.
    Overlapping instances are not found; so looking for "AA" in "AAA" finds just one range.
    Post 10.1: If kCFCompareBackwards is provided, the scan is done from the end (which can give a different result), and
        the results are stored in the array backwards (last found range in slot 0).
    If stringToFind is the empty string (zero length), nothing is found.
    kCFCompareAnchored causes just the consecutive instances at start (or end, if kCFCompareBackwards) to be reported. So, searching for "AB" in "ABABXAB..." you just get the first two occurrences.
    Ignores the kCFCompareNumerically option.
    Only the substring of theString specified by rangeToSearch is searched for stringToFind.
*/
extern CFArrayRef CFStringCreateArrayWithFindResults(CFAllocatorRef alloc, CFStringRef theString, CFStringRef stringToFind, CFRange rangeToSearch, CFStringCompareFlags compareOptions);
extern CFRange CFStringFind(CFStringRef theString, CFStringRef stringToFind, CFStringCompareFlags compareOptions);
extern bool CFStringHasPrefix(CFStringRef theString, CFStringRef prefix);
extern bool CFStringHasSuffix(CFStringRef theString, CFStringRef suffix);

/**
	@function CFStringGetRangeOfComposedCharactersAtIndex
	Returns the range of the composed character sequence at the specified index.
	@param theString The CFString which is to be searched.  If this
                		parameter is not a valid CFString, the behavior is
              		undefined.
	@param theIndex The index of the character contained in the
			composed character sequence.  If the index is
			outside the index space of the string (0 to N-1 inclusive,
			where N is the length of the string), the behavior is
			undefined.
	@result The range of the composed character sequence.
*/
extern CFRange CFStringGetRangeOfComposedCharactersAtIndex(CFStringRef theString, CFIndex theIndex);

/**
	@function CFStringFindCharacterFromSet
	Query the range of the first character contained in the specified character set.
	@param theString The CFString which is to be searched.  If this
                		parameter is not a valid CFString, the behavior is
              		undefined.
	@param theSet The CFCharacterSet against which the membership
			of characters is checked.  If this parameter is not a valid
			CFCharacterSet, the behavior is undefined.
	@param range The range of characters within the string to search. If
			the range location or end point (defined by the location
			plus length minus 1) are outside the index space of the
			string (0 to N-1 inclusive, where N is the length of the
			string), the behavior is undefined. If the range length is
			negative, the behavior is undefined. The range may be empty
			(length 0), in which case no search is performed.
	@param searchOptions The bitwise-or'ed option flags to control
			the search behavior.  The supported options are
			kCFCompareBackwards andkCFCompareAnchored.
			If other option flags are specified, the behavior
                        is undefined.
	@param result The pointer to a CFRange supplied by the caller in
			which the search result is stored.  Note that the length
			of this range can be more than 1, if for instance the 
			result is a composed character. If a pointer to an invalid
			memory is specified, the behavior is undefined.
	@result true, if at least a character which is a member of the character
			set is found and result is filled, otherwise, false.
*/
extern bool CFStringFindCharacterFromSet(CFStringRef theString, CFCharacterSetRef theSet, CFRange rangeToSearch, CFStringCompareFlags searchOptions, CFRange *result);

/* 
    Find range of bounds of the line(s) that span the indicated range (startIndex, numChars),
    taking into account various possible line separator sequences (CR, CRLF, LF, and Unicode NextLine, LineSeparator, ParagraphSeparator).
    All return values are "optional" (provide NULL if you don't want them)
        lineBeginIndex: index of first character in line
        lineEndIndex: index of first character of the next line (including terminating line separator characters)
        contentsEndIndex: index of the first line separator character
    Thus, lineEndIndex - lineBeginIndex is the number of chars in the line, including the line separators
        contentsEndIndex - lineBeginIndex is the number of chars in the line w/out the line separators
*/
extern void CFStringGetLineBounds(CFStringRef theString, CFRange range, CFIndex *lineBeginIndex, CFIndex *lineEndIndex, CFIndex *contentsEndIndex); 

/**
    Same as CFStringGetLineBounds(), however, will only look for paragraphs. Won't stop at Unicode NextLine or LineSeparator characters.
*/
extern void CFStringGetParagraphBounds(CFStringRef string, CFRange range, CFIndex *parBeginIndex, CFIndex *parEndIndex, CFIndex *contentsEndIndex);

/**
	@function CFStringGetHyphenationLocationBeforeIndex
	Retrieve the first potential hyphenation location found before the specified location.
	@param string The CFString which is to be hyphenated.  If this
                		parameter is not a valid CFString, the behavior is
              		undefined.
	@param location An index in the string.  If a valid hyphen index is returned, it 
	                will be before this index.
	@param limitRange The range of characters within the string to search. If
			the range location or end point (defined by the location
			plus length minus 1) are outside the index space of the
			string (0 to N-1 inclusive, where N is the length of the
			string), the behavior is undefined. If the range length is
			negative, the behavior is undefined. The range may be empty
			(length 0), in which case no hyphen location is generated.
	@param options Reserved for future use.
	@param locale Specifies which language's hyphenation conventions to use.
			This must be a valid locale.  Hyphenation data is not available
			for all locales.  You can use CFStringIsHyphenationAvailableForLocale
			to test for availability of hyphenation data.
	@param character The suggested hyphen character to insert.  Pass NULL if you
			do not need this information.
	@result an index in the string where it is appropriate to insert a hyphen, if
			one exists; else kCFNotFound
*/
extern CFIndex CFStringGetHyphenationLocationBeforeIndex(CFStringRef string, CFIndex location, CFRange limitRange, CFOptionFlags options, CFLocaleRef locale, UTF32Char *character);
extern bool CFStringIsHyphenationAvailableForLocale(CFLocaleRef locale);


extern CFStringRef CFStringCreateByCombiningStrings(CFAllocatorRef alloc, CFArrayRef theArray, CFStringRef separatorString);	/* Empty array returns empty string; one element array returns the element */
extern CFArrayRef CFStringCreateArrayBySeparatingStrings(CFAllocatorRef alloc, CFStringRef theString, CFStringRef separatorString);	/* No separators in the string returns array with that string; string == sep returns two empty strings */

/**
    Skips whitespace; returns 0 on error, MAX or -MAX on overflow
*/
extern SInt32 CFStringGetIntValue(CFStringRef str);

/**
    Skips whitespace; returns 0.0 on error
*/
extern double CFStringGetDoubleValue(CFStringRef str);

/* 
    CFStringAppend("abcdef", "xxxxx") -> "abcdefxxxxx"
    CFStringDelete("abcdef", CFRangeMake(2, 3)) -> "abf"
    CFStringReplace("abcdef", CFRangeMake(2, 3), "xxxxx") -> "abxxxxxf"
    CFStringReplaceAll("abcdef", "xxxxx") -> "xxxxx"
*/
extern void CFStringAppend(CFMutableStringRef theString, CFStringRef appendedString);
extern void CFStringAppendCharacters(CFMutableStringRef theString, const(UniChar)* chars, CFIndex numChars);
extern void CFStringAppendPascalString(CFMutableStringRef theString, ConstStr255Param pStr, CFStringEncoding encoding);
extern void CFStringAppendCString(CFMutableStringRef theString, const(char)* cStr, CFStringEncoding encoding);
extern void CFStringAppendFormat(CFMutableStringRef theString, CFDictionaryRef formatOptions, CFStringRef format, ...);
extern void CFStringInsert(CFMutableStringRef str, CFIndex idx, CFStringRef insertedStr);
extern void CFStringDelete(CFMutableStringRef theString, CFRange range);
extern void CFStringReplace(CFMutableStringRef theString, CFRange range, CFStringRef replacement);
extern void CFStringReplaceAll(CFMutableStringRef theString, CFStringRef replacement);	/* Replaces whole string */

/* 
    Replace all occurrences of target in rangeToSearch of theString with replacement.
    Pays attention to kCFCompareCaseInsensitive, kCFCompareBackwards, kCFCompareNonliteral, and kCFCompareAnchored.
    kCFCompareBackwards can be used to do the replacement starting from the end, which could give a different result.
        ex. AAAAA, replace AA with B -> BBA or ABB; latter if kCFCompareBackwards
    kCFCompareAnchored assures only anchored but multiple instances are found (the instances must be consecutive at start or end)
        ex. AAXAA, replace A with B -> BBXBB or BBXAA; latter if kCFCompareAnchored
    Returns number of replacements performed.
*/
extern CFIndex CFStringFindAndReplace(CFMutableStringRef theString, CFStringRef stringToFind, CFStringRef replacementString, CFRange rangeToSearch, CFStringCompareFlags compareOptions);


/* 
    This function will make the contents of a mutable CFString point directly at the specified UniChar array.
    It works only with CFStrings created with CFStringCreateMutableWithExternalCharactersNoCopy().
    This function does not free the previous buffer.
    The string will be manipulated within the provided buffer (if any) until it outgrows capacity; then the
        externalCharactersAllocator will be consulted for more memory.
    See comments at the top of this file for more info.
*/
extern void CFStringSetExternalCharactersNoCopy(CFMutableStringRef theString, UniChar *chars, CFIndex length, CFIndex capacity);	/* Works only on specially created mutable strings! */

/* 
    CFStringPad() will pad or cut down a string to the specified size.
    The pad string is used as the fill string; indexIntoPad specifies which character to start with.
        CFStringPad("abc", " ", 9, 0) ->  "abc      "
        CFStringPad("abc", ". ", 9, 1) -> "abc . . ."
        CFStringPad("abcdef", ?, 3, ?) -> "abc"

        CFStringTrim() will trim the specified string from both ends of the string.
        CFStringTrimWhitespace() will do the same with white space characters (tab, newline, etc)
        CFStringTrim("  abc ", " ") -> "abc"
        CFStringTrim("* * * *abc * ", "* ") -> "*abc "
*/
extern void CFStringPad(CFMutableStringRef theString, CFStringRef padString, CFIndex length, CFIndex indexIntoPad);
extern void CFStringTrim(CFMutableStringRef theString, CFStringRef trimString);
extern void CFStringTrimWhitespace(CFMutableStringRef theString);
extern void CFStringLowercase(CFMutableStringRef theString, CFLocaleRef locale);
extern void CFStringUppercase(CFMutableStringRef theString, CFLocaleRef locale);
extern void CFStringCapitalize(CFMutableStringRef theString, CFLocaleRef locale);

/*!
	@typedef CFStringNormalizationForm
	This is the type of Unicode normalization forms as described in
	Unicode Technical Report #15. To normalize for use with file
	system calls, use CFStringGetFileSystemRepresentation().
*/
enum CFStringNormalizationForm : CFIndex {
	
    /**
        Canonical Decomposition
    */
    FormD = 0,

	/**
        Compatibility Decomposition
    */
    FormKD,

	/**
        Canonical Decomposition followed by Canonical Composition
    */
    FormC,

	/**
        Compatibility Decomposition followed by Canonical Composition
    */
    FormKC
}

/*!
	@function CFStringNormalize
	Normalizes the string into the specified form as described in
	Unicode Technical Report #15.
	@param theString  The string which is to be normalized.  If this
		parameter is not a valid mutable CFString, the behavior is
		undefined.
	@param theForm  The form into which the string is to be normalized.
		If this parameter is not a valid CFStringNormalizationForm value,
		the behavior is undefined.
*/
extern void CFStringNormalize(CFMutableStringRef theString, CFStringNormalizationForm theForm);


/*!
	@function CFStringFold
	Folds the string into the form specified by the flags.
		Character foldings are operations that convert any of a set of characters
		sharing similar semantics into a single representative from that set.
		This function can be used to preprocess strings that are to be compared,
		searched, or indexed.
		Note that folding does not include normalization, so it is necessary
		to use CFStringNormalize in addition to CFStringFold in order to obtain
		the effect of kCFCompareNonliteral.
	@param theString  The string which is to be folded.  If this parameter is not
		a valid mutable CFString, the behavior is undefined.
	@param theFlag  The equivalency flags which describes the character folding form.
		Only those flags containing the word "insensitive" are recognized here; other flags are ignored.		
		Folding with kCFCompareCaseInsensitive removes case distinctions in accordance with the mapping
		specified by ftp://ftp.unicode.org/Public/UNIDATA/CaseFolding.txt.  Folding with
		kCFCompareDiacriticInsensitive removes distinctions of accents and other diacritics.  Folding
		with kCFCompareWidthInsensitive removes character width distinctions by mapping characters in
		the range U+FF00-U+FFEF to their ordinary equivalents.
	@param theLocale The locale tailoring the character folding behavior. If NULL,
		it's considered to be the system locale returned from CFLocaleGetSystem().
		If non-NULL and not a valid CFLocale object, the behavior is undefined.
*/

extern void CFStringFold(CFMutableStringRef theString, CFStringCompareFlags theFlags, CFLocaleRef theLocale);

/*
    Perform string transliteration.
    
    The transformation represented by transform is applied to the given range of string, modifying it in place.
    Only the specified range will be modified, but the transform may look at portions of the string outside that range for context.
    NULL range pointer causes the whole string to be transformed. On return, range is modified to reflect the new range corresponding to the original range.
    reverse indicates that the inverse transform should be used instead, if it exists. 
    If the transform is successful, true is returned; if unsuccessful, false.
    Reasons for the transform being unsuccessful include an invalid transform identifier, or attempting to reverse an irreversible transform.

    You can pass one of the predefined transforms below, or any valid ICU transform ID as defined in the ICU User Guide.
    
    Note that we do not support arbitrary set of ICU transform rules.
*/
extern bool CFStringTransform(CFMutableStringRef string, CFRange *range, CFStringRef transform, bool reverse);

/* Transform identifiers for CFStringTransform() */
extern const CFStringRef kCFStringTransformStripCombiningMarks;
extern const CFStringRef kCFStringTransformToLatin;
extern const CFStringRef kCFStringTransformFullwidthHalfwidth;
extern const CFStringRef kCFStringTransformLatinKatakana;
extern const CFStringRef kCFStringTransformLatinHiragana;
extern const CFStringRef kCFStringTransformHiraganaKatakana;
extern const CFStringRef kCFStringTransformMandarinLatin;
extern const CFStringRef kCFStringTransformLatinHangul;
extern const CFStringRef kCFStringTransformLatinArabic;
extern const CFStringRef kCFStringTransformLatinHebrew;
extern const CFStringRef kCFStringTransformLatinThai;
extern const CFStringRef kCFStringTransformLatinCyrillic;
extern const CFStringRef kCFStringTransformLatinGreek;
extern const CFStringRef kCFStringTransformToXMLHex;
extern const CFStringRef kCFStringTransformToUnicodeName;
extern const CFStringRef kCFStringTransformStripDiacritics;


/**
    This returns availability of the encoding on the system
*/
extern bool CFStringIsEncodingAvailable(CFStringEncoding encoding);

/**
    This function returns list of available encodings.
    
    The returned list is terminated with kCFStringEncodingInvalidId and owned by the system.
*/
extern const(CFStringEncoding)* CFStringGetListOfAvailableEncodings();

/**
    Returns name of the encoding; non-localized.
*/
extern CFStringRef CFStringGetNameOfEncoding(CFStringEncoding encoding);

/**
    ID mapping functions from/to Cocoa NSStringEncoding.
    
    Returns kCFStringEncodingInvalidId if no mapping exists.
*/
extern ulong CFStringConvertEncodingToNSStringEncoding(CFStringEncoding encoding);
extern CFStringEncoding CFStringConvertNSStringEncodingToEncoding(ulong encoding);

/**
    ID mapping functions from/to Microsoft Windows codepage (covers both OEM & ANSI).
    
    Returns kCFStringEncodingInvalidId if no mapping exists.
*/
extern UInt32 CFStringConvertEncodingToWindowsCodepage(CFStringEncoding encoding);
extern CFStringEncoding CFStringConvertWindowsCodepageToEncoding(UInt32 codepage);

/*
    ID mapping functions from/to IANA registery charset names.
    
    Returns kCFStringEncodingInvalidId if no mapping exists.
*/
extern CFStringEncoding CFStringConvertIANACharSetNameToEncoding(CFStringRef theString);
extern CFStringRef  CFStringConvertEncodingToIANACharSetName(CFStringEncoding encoding);

/**
    Returns the most compatible MacOS script value for the input encoding, i.e.  
        * CFStringEncoding.MacRoman -> CFStringEncoding.MacRoman
        * CFStringEncoding.WindowsLatin1 -> CFStringEncoding.MacRoman
        * CFStringEncoding.ISO_2022_JP -> CFStringEncoding.MacJapanese
*/
extern CFStringEncoding CFStringGetMostCompatibleMacStringEncoding(CFStringEncoding encoding);
