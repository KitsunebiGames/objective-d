/*
    Copyright © 2024, Inochi2D Project
    Distributed under the 2-Clause BSD License, see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Bindings to NSString
*/
module foundation.nsstring;
import foundation;
import objc;

import core.attribute : selector, optional;

/**
    The following constants are provided by NSString as 
    possible string encodings.
*/
enum NSStringEncoding : NSUInteger {
    
    /**
        Strict 7-bit ASCII encoding within 8-bit chars; 
        ASCII values 0…127 only.
    */
    ASCII = 1,
    
    /**
        8-bit ASCII encoding with NEXTSTEP extensions.
    */
    NextStep = 2,
    
    /**
        8-bit EUC encoding for Japanese text.
    */
    JEUC = 3,
    
    /**
        An 8-bit representation of Unicode characters, suitable for 
        transmission or storage by ASCII-based systems.
    */
    UTF8 = 4,
    
    /**
        8-bit ISO Latin 1 encoding.
    */
    ISOLatin1 = 5,
    
    /**
        8-bit Adobe Symbol encoding vector.
    */
    Symbol = 6,
    
    /**
        7-bit verbose ASCII to represent all Unicode characters.
    */
    NonLossyASCII = 7,
    
    /**
        8-bit Shift-JIS encoding for Japanese text.
    */
    ShiftJIS = 8,
    
    /**
        8-bit ISO Latin 2 encoding.
    */
    ISOLatin2 = 9,
    
    /**
        The canonical Unicode encoding for string objects.
    */
    Unicode = 10,
    
    /**
        Microsoft Windows codepage 1251, encoding Cyrillic characters; 
        equivalent to AdobeStandardCyrillic font encoding.
    */
    WindowsCP1251 = 11,
    
    /**
        Microsoft Windows codepage 1252; equivalent to WinLatin1.
    */
    WindowsCP1252 = 12,
    
    /**
        Microsoft Windows codepage 1253, encoding Greek characters.
    */
    WindowsCP1253 = 13,
    
    /**
        Microsoft Windows codepage 1254, encoding Turkish characters.
    */
    WindowsCP1254 = 14,
    
    /**
        Microsoft Windows codepage 1250; equivalent to WinLatin2.
    */
    WindowsCP1250 = 15,
    
    /**
        ISO 2022 Japanese encoding for email.
    */
    ISO2022JP = 21,
    
    /**
        Classic Macintosh Roman encoding.
    */
    MacOSRoman = 30,
    
    /**
        Classic Macintosh Japanese encoding.
    */
    MacOSJapanese           = 0x80000001,
    
    /**
        Classic Macintosh Traditional Chinese encoding.
    */
    MacOSTraditionalChinese = 0x80000002,
    
    /**
        Classic Macintosh Korean encoding.
    */
    MacOSKorean             = 0x80000003,
    
    /**
        Classic Macintosh Arabic encoding.
    */
    MacOSArabic             = 0x80000004,
    
    /**
        Classic Macintosh Hebrew encoding.
    */
    MacOSHebrew             = 0x80000005,
    
    /**
        Classic Macintosh Greek encoding.
    */
    MacOSGreek              = 0x80000006,
    
    /**
        Classic Macintosh Cyrillic encoding.
    */
    MacOSCyrillic           = 0x80000007,
    
    /**
        Classic Macintosh Devanagari encoding.
    */
    MacOSDevanagari         = 0x80000009,
    
    /**
        Classic Macintosh Gurmukhi encoding.
    */
    MacOSGurmukhi           = 0x8000000a,
    
    /**
        Classic Macintosh Gujarati encoding.
    */
    MacOSGujarati           = 0x8000000b,
    
    /**
        Classic Macintosh Oriya encoding.
    */
    MacOSOriya              = 0x8000000c,
    
    /**
        Classic Macintosh Bengali encoding.
    */
    MacOSBengali            = 0x8000000d,
    
    /**
        Classic Macintosh Tamil encoding.
    */
    MacOSTamil              = 0x8000000e,
    
    /**
        Classic Macintosh Telugu encoding.
    */
    MacOSTelugu             = 0x8000000f,
    
    /**
        Classic Macintosh Kannada encoding.
    */
    MacOSKannada            = 0x80000010,
    
    /**
        Classic Macintosh Malayalam encoding.
    */
    MacOSMalayalam          = 0x80000011,
    
    /**
        Classic Macintosh Sinhalese encoding.
    */
    MacOSSinhalese          = 0x80000012,
    
    /**
        Classic Macintosh Burmese encoding.
    */
    MacOSBurmese            = 0x80000013,
    
    /**
        Classic Macintosh Khmer encoding.
    */
    MacOSKhmer              = 0x80000014,
    
    /**
        Classic Macintosh Thai encoding.
    */
    MacOSThai               = 0x80000015,
    
    /**
        Classic Macintosh Laotian encoding.
    */
    MacOSLaotian            = 0x80000016,
    
    /**
        Classic Macintosh Georgian encoding.
    */
    MacOSGeorgian           = 0x80000017,
    
    /**
        Classic Macintosh Armenian encoding.
    */
    MacOSArmenian           = 0x80000018,
    
    /**
        Classic Macintosh Simplified Chinese encoding.
    */
    MacOSSimplifiedChinese  = 0x80000019,
    
    /**
        Classic Macintosh Tibetan encoding.
    */
    MacOSTibetan            = 0x8000001a,
    
    /**
        Classic Macintosh Mongolian encoding.
    */
    MacOSMongolian          = 0x8000001b,
    
    /**
        Classic Macintosh Ethiopic encoding.
    */
    MacOSEthiopic           = 0x8000001c,
    
    /**
        Classic Macintosh Central-european Roman encoding.
    */
    MacOSCentralEuropeanRoman = 0x8000001d,
    
    /**
        Classic Macintosh Vietnamese encoding.
    */
    MacOSVietnamese         = 0x8000001e,
    
    /**
        Classic Macintosh Extended Arabic encoding.
    */
    MacOSExtendedArabic     = 0x8000001f,
    
    /**
        Code page 437
    */
    DOSLatinUS              = 0x80000400,
    
    /**
        Code page 737 (formerly code page 437G)
    */
    DOSGreek                = 0x80000405,
    
    /**
        Code page 775
    */
    DOSBalticRim            = 0x80000406,
    
    /**
        Code page 850, "Multilingual"
    */
    DOSLatin1               = 0x80000410,
    
    /**
        Code page 851
    */
    DOSGreek1               = 0x80000411,
    
    /**
        Code page 852, Slavic
    */
    DOSLatin2               = 0x80000412,
    
    /**
        Code page 855, IBM Cyrillic
    */
    DOSCyrillic             = 0x80000413,
    
    /**
        Code page 857, IBM Turkish
    */
    DOSTurkish              = 0x80000414,
    
    /**
        Code page 860
    */
    DOICortuguese           = 0x80000415,
    
    /**
        Code page 861
    */
    DOSIcelandic            = 0x80000416,
    
    /**
        Code page 862
    */
    DOSHebrew               = 0x80000417,
    
    /**
        Code page 863
    */
    DOSCanadianFrench       = 0x80000418,
    
    /**
        Code page 864
    */
    DOSArabic               = 0x80000419,
    
    /**
        Code page 865
    */
    DOSNordic               = 0x8000041A,
    
    /**
        Code page 866
    */
    DOSRussian              = 0x8000041B,
    
    /**
        Code page 869
    */
    DOSGreek2               = 0x8000041C,
    
    /**
        Code page 874
    */
    DOSThai                 = 0x8000041D,
    
    /**
        Code page 932
    */
    DOSJapanese             = 0x80000420,
    
    /**
        Code page 936
    */
    DOSChineseSimplified    = 0x80000421,
    
    /**
        Code page 949
        
        Unified Hangul Code
    */
    DOSKorean               = 0x80000422,
    
    /**
        Code page 950
    */
    DOSChineseTraditional   = 0x80000423,  /* , also for Windows */
    
    /**
        Code page 1252
    */
    WindowsLatin1           = 0x80000500,
    
    /**
        Code page 1250

        Central Europe
    */
    WindowsLatin2           = 0x80000501,
    
    /**
        Code page 1251

        Slavic Cyrillic
    */
    WindowsCyrillic         = 0x80000502,
    
    /**
        Code page 1253
    */
    WindowsGreek            = 0x80000503,
    
    /**
        Code page 1254

        Turkish
    */
    WindowsLatin5           = 0x80000504,
    
    /**
        Code page 1255
    */
    WindowsHebrew           = 0x80000505,
    
    /**
        Code page 1256
    */
    WindowsArabic           = 0x80000506,
    
    /**
        Code page 1257
    */
    WindowsBalticRim        = 0x80000507,
    
    /**
        Code page 1258
    */
    WindowsVietnamese       = 0x80000508,
    
    /**
        Code page 1361
    */
    WindowsKoreanJohab      = 0x80000510,

    /**
        UTF16
    */
    UTF16 = 0x90000100,
    
    /**
        UTF-16 (Big Endian)
    */
    UTF16BE = 0x90000100,
    
    /**
        UTF-16 (Little Endian)
    */
    UTF16LE = 0x94000100,
    
    /**
        UTF-32
    */
    UTF32 = 0x8c000100,
    
    /**
        UTF-32 (Big Endian)
    */
    UTF32BE = 0x98000100,
    
    /**
        UTF-32 (Little Endian)
    */
    UTF32LE = 0x9c000100,
}

/**
    A block which enumerates all the lines in the string.
*/
alias NSStringEnumerator = Block!(void, NSString, bool*);

/**
    NSString
*/
extern(Objective-C)
extern class NSString : NSObject, NSCopying, NSMutableCopying, NSSecureCoding {
@nogc nothrow:
public:

    /**
        Returns an empty string.
    */
    static NSString create() @selector("string");

    /**
        Returns a string created by copying the data from 
        a given C array of UTF8-encoded bytes.
    */
    static NSString create(const(char)* str) @selector("stringWithUTF8String:");

    /**
        Returns a string containing the bytes in a given C array, 
        interpreted according to a given encoding.
    */
    static NSString create(const(char)* str, NSStringEncoding encoding) @selector("stringWithCString:encoding:");

    /**
        Returns a string created by copying the characters from another given string.
    */
    static NSString create(ref NSString other) @selector("stringWithString:");

    /**
        Allocates a new NSString
    */
    override static NSString alloc() @selector("alloc");

    /**
        Returns a string created by copying the data from a 
        given C array of UTF8-encoded bytes.
    */
    static NSString fromUTF8String(const(char)* str) @selector("stringWithUTF8String:");

    /**
        Returns an initialized NSString object.
    */
    override NSString init() @selector("init");

    /**
        Returns an NSString object initialized by copying the characters 
        from a given C array of UTF8-encoded bytes.
    */
    NSString init(const(char)* str) @selector("initWithUTF8String:");

    /**
        A lowercase representation of the string.
    */
    @property NSString toLower() @selector("lowercaseString");

    /**
        Returns a version of the string with all letters converted to 
        lowercase, taking into account the current locale.
    */
    @property NSString toLowerLocalized() @selector("localizedLowercaseString");

    /**
        An uppercase representation of the string.
    */
    @property NSString toUpper() @selector("uppercaseString");

    /**
        Returns a version of the string with all letters converted to 
        uppercase, taking into account the current locale.
    */
    @property NSString toUpperLocalized() @selector("localizedUppercaseString");

    /**
        A capitalized representation of the string.
    */
    @property NSString toCapitalized() @selector("capitalizedString");

    /**
        Returns a capitalized representation of the receiver using the current locale.
    */
    @property NSString toCapitalizedLocalized() @selector("localizedUppercaseString");

    /**
        A Boolean value that indicates whether or not the class 
        supports secure coding.
    */
    @property bool supportsSecureCoding() @selector("supportsSecureCoding");

    /**
        The number of UTF-16 code units in the receiver.
    */
    @property NSUInteger length() const @selector("length");

    /**
        A null-terminated UTF8 representation of the string.

        This C string is a pointer to a structure inside the string object, 
        which may have a lifetime shorter than the string object and will certainly 
        not have a longer lifetime. 
        
        Therefore, you should copy the C string if it needs to be stored outside of the 
        memory context in which you use this property.
    */
    @property const(char)* ptr() const @selector("UTF8String");

    /**
        Returns a representation of the string as a C string 
        using a given encoding.

        The returned C string is guaranteed to be valid only until either the 
        receiver is freed, or until the current memory is emptied, whichever occurs first. 
        
        You should copy the C string or use the `toCString(char*, NSUInteger, NSStringEncoding)` 
        function if it needs to store the C string beyond this time.
    */
    const(char)* toCString(NSStringEncoding encoding) @selector("cStringUsingEncoding:");

    /**
        Converts the string to a given encoding and stores it in a buffer.

        Returns:
            Whether the operation was successful.
    */
    bool toCString(char* buffer, NSUInteger length, NSStringEncoding encoding) @selector("getCString:maxLength:encoding:");

    /**
        Returns a Boolean value indicating whether the string contains a given 
        string by performing a case-sensitive, locale-unaware search.
    */
    bool contains(NSString other) @selector("containsString:");

    /**
        urns a Boolean value indicating whether the string contains a given 
        string by performing a case-insensitive, locale-aware search.
    */
    bool caseInsensitiveContains(NSString other) @selector("localizedCaseInsensitiveContainsString:");

    /**
        Finds and returns the range of the first occurrence of a given string within the string.
    */
    NSRange firstOf(NSString other) @selector("localizedCaseInsensitiveContainsString:");

    /**
        Enumerates all the lines in the string using the provided block.
    */
    void enumerateLines(NSStringEnumerator enumerator) @selector("enumerateLinesUsingBlock:");

    /**
        Returns a Boolean value that indicates whether a given string is equal 
        to the receiver using a literal Unicode-based comparison.
    */
    bool opEquals(inout(NSString) other) inout @selector("isEqualToString:");
    
    /**
        Encodes the receiver using a given archiver.
    */
    void encodeWithCoder(NSCoder coder) @selector("encodeWithCoder:");

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id mutableCopyWithZone(NSZone* zone) @selector("mutableCopyWithZone:");

    /**
        Returns a new instance that’s a copy of the receiver.
    */
    id copyWithZone(NSZone* zone) @selector("copyWithZone:");
}

/**
    A mutable string.
*/
extern(Objective-C)
extern class NSMutableString : NSString {
@nogc nothrow:
public:

    /**
        Appends the given string to this string.
    */
    void append(NSString other) @selector("appendString:");

    /**
        Inserts a string into this string at the specified index.
    */
    void insert(NSString other, NSUInteger index) @selector("insertString:atIndex:");
}