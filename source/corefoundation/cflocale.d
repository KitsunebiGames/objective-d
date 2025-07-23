/*
    CoreFoundation Data

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cflocale;
import corefoundation.cfallocator;
import corefoundation.cfdictionary;
import corefoundation.cfstring;
import corefoundation.cfarray;
import corefoundation.core;

extern(C) @nogc nothrow:

/**
    A CoreFoundation Locale
*/
alias CFLocaleRef = CFSubType!("CFLocale");

/**
    Writing direction of a language.
*/
enum CFLocaleLanguageDirection : CFIndex {
    kUnknown = 0,
    kLeftToRight = 1,
    kRightToLeft = 2,
    kTopToBottom = 3,
    kBottomToTop = 4
}

alias CFLocaleIdentifier = CFStringRef;

// Locale Keys
alias CFLocaleKey = CFStringRef;
extern __gshared const CFLocaleKey kCFLocaleIdentifier;
extern __gshared const CFLocaleKey kCFLocaleLanguageCode;
extern __gshared const CFLocaleKey kCFLocaleCountryCode;
extern __gshared const CFLocaleKey kCFLocaleScriptCode;
extern __gshared const CFLocaleKey kCFLocaleVariantCode;
extern __gshared const CFLocaleKey kCFLocaleExemplarCharacterSet;
extern __gshared const CFLocaleKey kCFLocaleCalendarIdentifier;
extern __gshared const CFLocaleKey kCFLocaleCalendar;
extern __gshared const CFLocaleKey kCFLocaleCollationIdentifier;
extern __gshared const CFLocaleKey kCFLocaleUsesMetricSystem;
extern __gshared const CFLocaleKey kCFLocaleMeasurementSystem; // "Metric", "U.S." or "U.K."
extern __gshared const CFLocaleKey kCFLocaleDecimalSeparator;
extern __gshared const CFLocaleKey kCFLocaleGroupingSeparator;
extern __gshared const CFLocaleKey kCFLocaleCurrencySymbol;
extern __gshared const CFLocaleKey kCFLocaleCurrencyCode; // ISO 3-letter currency code
extern __gshared const CFLocaleKey kCFLocaleCollatorIdentifier;
extern __gshared const CFLocaleKey kCFLocaleQuotationBeginDelimiterKey;
extern __gshared const CFLocaleKey kCFLocaleQuotationEndDelimiterKey;
extern __gshared const CFLocaleKey kCFLocaleAlternateQuotationBeginDelimiterKey;
extern __gshared const CFLocaleKey kCFLocaleAlternateQuotationEndDelimiterKe;

// Values for kCFLocaleCalendarIdentifier
alias CFCalendarIdentifier = CFStringRef;
extern __gshared const CFCalendarIdentifier kCFGregorianCalendar;
extern __gshared const CFCalendarIdentifier kCFBuddhistCalendar;
extern __gshared const CFCalendarIdentifier kCFChineseCalendar;
extern __gshared const CFCalendarIdentifier kCFHebrewCalendar;
extern __gshared const CFCalendarIdentifier kCFIslamicCalendar;
extern __gshared const CFCalendarIdentifier kCFIslamicCivilCalendar;
extern __gshared const CFCalendarIdentifier kCFJapaneseCalendar;
extern __gshared const CFCalendarIdentifier kCFRepublicOfChinaCalendar;
extern __gshared const CFCalendarIdentifier kCFPersianCalendar;
extern __gshared const CFCalendarIdentifier kCFIndianCalendar;
extern __gshared const CFCalendarIdentifier kCFISO8601Calendar;
extern __gshared const CFCalendarIdentifier kCFIslamicTabularCalendar;
extern __gshared const CFCalendarIdentifier kCFIslamicUmmAlQuraCalendar;

/**
    Gets the Type ID of the CFLocaleRef Type
*/
extern CFTypeID CFLocaleGetTypeID();

/**
    Gets the base system locale.

    Returns:
        The root/canonical locale of the system.
*/
extern CFLocaleRef CFLocaleGetSystem();

/**
    Gets the current user locale.

    Returns:
        The logical "user" locale for the current user.
*/
extern CFLocaleRef CFLocaleCopyCurrent();

/**
    Gets a list of locales.

    Returns:
        An array of CFStrings that represents all locales for
        all known legal ISO language codes.
*/
extern CFArrayRef CFLocaleCopyAvailableLocaleIdentifiers();

/**
    Gets a list of languages.

    Returns:
        An array of CFStrings that represents all known legal ISO
	    language codes.

    Note:
        Many of these will not have any supporting
	    locale data in Mac OS X.
*/
extern CFArrayRef CFLocaleCopyISOLanguageCodes();

/**
    Gets a list of country codes.

    Returns:
        An array of CFStrings that represents all known legal ISO
	    country codes.

    Note:
        Many of these will not have any supporting
	    locale data in Mac OS X.
*/
extern CFArrayRef CFLocaleCopyISOCountryCodes();

/**
    Gets a list of currency codes.

    Returns:
        an array of CFStrings that represents all known legal ISO
	    currency codes.

    Note:
        Some of these currencies may be obsolete, or
	    represent other financial instruments.
*/
extern CFArrayRef CFLocaleCopyCommonISOCurrencyCodes();

/**
    Gets a list of commonly used currency codes.

    Returns:
        An array of CFStrings that represents ISO currency codes for
	    currencies in common use.
*/
extern CFArrayRef CFLocaleCopyCommonISOCurrencyCodes();

/**
    Gets a list of languages the user prefers.

    Returns:
        An array of canonicalized CFString locale IDs 
        that the user prefers.
*/
extern CFArrayRef CFLocaleCopyPreferredLanguages();

/**
    Maps an arbitrary language identification string
    (something close at least) to a canonical language 
    identifier.
*/
extern CFLocaleIdentifier CFLocaleCreateCanonicalLanguageIdentifierFromString(CFAllocatorRef allocator, CFStringRef localeIdentifier);

/**
    Map an arbitrary locale identification string
    (something close at least) to the canonical
    identifier
*/
extern CFLocaleIdentifier CFLocaleCreateCanonicalLocaleIdentifierFromString(CFAllocatorRef allocator, CFStringRef localeIdentifier);

/**
    Map a Mac OS LangCode and RegionCode to the 
    canonical locale identifier.
*/
extern CFLocaleIdentifier CFLocaleCreateCanonicalLocaleIdentifierFromString(CFAllocatorRef allocator, LangCode lcode, RegionCode rcode);

/**
    Map a Windows LCID to the canonical locale identifier.
*/
extern CFLocaleIdentifier CFLocaleCreateLocaleIdentifierFromWindowsLocaleCode(CFAllocatorRef allocator, uint lcid);

/**
    Map a locale identifier to a Windows LCID.
*/
extern uint CFLocaleGetWindowsLocaleCodeFromLocaleIdentifier(CFLocaleIdentifier localeIdentifier);

/**
    Gets the character direction for the given language code.
*/
extern CFLocaleLanguageDirection CFLocaleGetLanguageCharacterDirection(CFStringRef isoLangCode);

/**
    Gets the line direction for the given language code.
*/
extern CFLocaleLanguageDirection CFLocaleGetLanguageLineDirection(CFStringRef isoLangCode);

/**
    Parses a locale ID consisting of language, script, country, variant,
	and keyword/value pairs into a dictionary. The keys are the constant
	CFStrings corresponding to the locale ID components, and the values
	will correspond to constants where available.

	Examples:
        "en_US@calendar=japanese" yields a dictionary with three
	    entries: kCFLocaleLanguageCode=en, kCFLocaleCountryCode=US, and
	    kCFLocaleCalendarIdentifier=kCFJapaneseCalendar.
*/
extern CFDictionaryRef CFLocaleCreateComponentsFromLocaleIdentifier(CFAllocatorRef allocator, CFLocaleIdentifier localeID);

/**
	Reverses the actions of CFLocaleCreateDictionaryFromLocaleIdentifier,
	creating a single string from the data in the dictionary. The
	dictionary {kCFLocaleLanguageCode=en, kCFLocaleCountryCode=US,
	kCFLocaleCalendarIdentifier=kCFJapaneseCalendar} becomes
	"en_US@calendar=japanese".
*/
extern CFLocaleIdentifier CFLocaleCreateLocaleIdentifierFromComponents(CFAllocatorRef allocator, CFDictionaryRef dictionary);

/**
    Creates a locale from an identifier.

    Returns:
        A CFLocaleRef for the locale named by the "arbitrary" locale identifier.
*/
extern CFLocaleRef CFLocaleCreate(CFAllocatorRef allocator, CFLocaleIdentifier localeIdentifier);

/**
	Having gotten a CFLocale from somebody, code should make a copy
	if it is going to use it for several operations
	or hold onto it.  In the future, there may be mutable locales.
*/
extern CFLocaleRef CFLocaleCreateCopy(CFAllocatorRef allocator, CFLocaleRef locale);

/**
    Gets the identifier for a locale.

	Returns:
        The locale's identifier.  This may not be the same string
	    that the locale was created with (CFLocale may canonicalize it).
*/
extern CFLocaleIdentifier CFLocaleGetIdentifier(CFLocaleRef locale);

/**
    Gets the given value for the given key for a locale.

	Returns:
        The value for the given key.  This is how settings and state
	    are accessed via a CFLocale.  Values might be of any CF type.
*/
extern CFTypeRef CFLocaleGetValue(CFLocaleRef locale, CFLocaleKey key);

/**
    Gets the display name for a locale's property value.

    Returns:
        The display name for the given value.  The key tells what
	    the value is, and is one of the usual locale property keys, though
	    not all locale property keys have values with display name values.
*/
extern CFStringRef CFLocaleCopyDisplayNameForPropertyValue(CFLocaleRef displayLocale, CFLocaleKey key, CFStringRef value);
