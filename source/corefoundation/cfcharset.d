/*
    CoreFoundation Character Set

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfcharset;
import corefoundation.cfallocator;
import corefoundation.cfstring;
import corefoundation.cfdata;
import corefoundation.core;

extern (C) @nogc nothrow:

enum CFCharacterSetPredefinedSet : CFIndex {
    /**
        Control character set (Unicode General Category Cc and Cf)
    */
    kCFCharacterSetControl = 1,

    /**
        Whitespace character set (Unicode General Category Zs and U0009 CHARACTER TABULATION)    
    */
    kCFCharacterSetWhitespace,

    /**
        Whitespace and Newline character set (Unicode General Category Z*, U000A ~ U000D, and U0085)    
    */
    kCFCharacterSetWhitespaceAndNewline,

    /**
        Decimal digit character set    
    */
    kCFCharacterSetDecimalDigit,

    /**
        Letter character set (Unicode General Category L* & M*)    
    */
    kCFCharacterSetLetter,

    /**
        Lowercase character set (Unicode General Category Ll)    
    */
    kCFCharacterSetLowercaseLetter,

    /**
        Uppercase character set (Unicode General Category Lu and Lt)    
    */
    kCFCharacterSetUppercaseLetter,

    /**
        Non-base character set (Unicode General Category M*)    
    */
    kCFCharacterSetNonBase,

    /**
        Canonically decomposable character set    
    */
    kCFCharacterSetDecomposable,

    /**
        Alpha Numeric character set (Unicode General Category L*, M*, & N*)    
    */
    kCFCharacterSetAlphaNumeric,

    /**
        Punctuation character set (Unicode General Category P*)    
    */
    kCFCharacterSetPunctuation,

    /**
        Titlecase character set (Unicode General Category Lt)    
    */
    kCFCharacterSetCapitalizedLetter = 13,

    /**
        Symbol character set (Unicode General Category S*)    
    */
    kCFCharacterSetSymbol = 14,

    /**
        Newline character set (U000A ~ U000D, U0085, U2028, and U2029)    
    */
    kCFCharacterSetNewline = 15,

    /**
        Illegal character set    
    */
    kCFCharacterSetIllegal = 12
}

/**
    A CoreFoundation Data Store
*/
// @objd_bridge!(CFCharacterSetRef, NSCharacterSet)
alias CFCharacterSetRef = CFSubType!("CFCharacterSet");

/**
    A CoreFoundation Data Store
*/
// @objd_bridge!(CFMutableCharacterSetRef, NSMutableCharacterSet)
alias CFMutableCharacterSetRef = CFSubType!("CFCharacterSet");


/*!
	@function CFCharacterSetGetTypeID
	Returns the type identifier of all CFCharacterSet instances.
*/
extern CFTypeID CFCharacterSetGetTypeID();

/*!
	@function CFCharacterSetGetPredefined
	Returns a predefined CFCharacterSet instance.
	@param theSetIdentifier The CFCharacterSetPredefinedSet selector
                which specifies the predefined character set.  If the
                value is not in CFCharacterSetPredefinedSet, the behavior
                is undefined.
	@result A reference to the predefined immutable CFCharacterSet.
                This instance is owned by CF.
*/
extern CFCharacterSetRef CFCharacterSetGetPredefined(CFCharacterSetPredefinedSet theSetIdentifier);

/*!
	@function CFCharacterSetCreateWithCharactersInRange
	Creates a new immutable character set with the values from the given range.
	@param alloc The CFAllocator which should be used to allocate
		memory for the array and its storage for values. This
		parameter may be NULL in which case the current default
		CFAllocator is used. If this reference is not a valid
		CFAllocator, the behavior is undefined.
	@param theRange The CFRange which should be used to specify the
                Unicode range the character set is filled with.  It
                accepts the range in 32-bit in the UTF-32 format.  The
                valid character point range is from 0x00000 to 0x10FFFF.
                If the range is outside of the valid Unicode character
                point, the behavior is undefined.
	@result A reference to the new immutable CFCharacterSet.
*/
extern CFCharacterSetRef CFCharacterSetCreateWithCharactersInRange(CFAllocatorRef alloc, CFRange theRange);

/*!
	@function CFCharacterSetCreateWithCharactersInString
	Creates a new immutable character set with the values in the given string.
	@param alloc The CFAllocator which should be used to allocate
		memory for the array and its storage for values. This
		parameter may be NULL in which case the current default
		CFAllocator is used. If this reference is not a valid
		CFAllocator, the behavior is undefined.
	@param theString The CFString which should be used to specify
                the Unicode characters the character set is filled with.
                If this parameter is not a valid CFString, the behavior
                is undefined.
        @result A reference to the new immutable CFCharacterSet.
*/
extern CFCharacterSetRef CFCharacterSetCreateWithCharactersInString(CFAllocatorRef alloc, CFStringRef theString);

/*!
	@function CFCharacterSetCreateWithBitmapRepresentation
	Creates a new immutable character set with the bitmap representtion in the given data.
	@param alloc The CFAllocator which should be used to allocate
		memory for the array and its storage for values. This
		parameter may be NULL in which case the current default
		CFAllocator is used. If this reference is not a valid
		CFAllocator, the behavior is undefined.
	@param theData The CFData which should be used to specify the
                bitmap representation of the Unicode character points
                the character set is filled with.  The bitmap
                representation could contain all the Unicode character
                range starting from BMP to Plane 16.  The first 8192 bytes
                of the data represent the BMP range.  The BMP range 8192
                bytes can be followed by zero to sixteen 8192 byte
                bitmaps, each one with the plane index byte prepended.
                For example, the bitmap representing the BMP and Plane 2
                has the size of 16385 bytes (8192 bytes for BMP, 1 byte
                index + 8192 bytes bitmap for Plane 2).  The plane index
                byte, in this case, contains the integer value two.  If
                this parameter is not a valid CFData or it contains a
                Plane index byte outside of the valid Plane range
                (1 to 16), the behavior is undefined.
        @result A reference to the new immutable CFCharacterSet.
*/
extern CFCharacterSetRef CFCharacterSetCreateWithBitmapRepresentation(CFAllocatorRef alloc, CFDataRef theData);

/*!
	@function CFCharacterSetCreateInvertedSet
	Creates a new immutable character set that is the invert of the specified character set.
	@param alloc The CFAllocator which should be used to allocate
			memory for the array and its storage for values. This
			parameter may be NULL in which case the current default
			CFAllocator is used. If this reference is not a valid
			CFAllocator, the behavior is undefined.
	@param theSet The CFCharacterSet which is to be inverted.  If this
                		parameter is not a valid CFCharacterSet, the behavior is
              		undefined.
	@result A reference to the new immutable CFCharacterSet.
*/
extern CFCharacterSetRef CFCharacterSetCreateInvertedSet(CFAllocatorRef alloc, CFCharacterSetRef theSet);

/*!
	@function CFCharacterSetIsSupersetOfSet
	Reports whether or not the character set is a superset of the character set specified as the second parameter.
	@param theSet  The character set to be checked for the membership of theOtherSet.
		If this parameter is not a valid CFCharacterSet, the behavior is undefined.
	@param theOtherset  The character set to be checked whether or not it is a subset of theSet.
		If this parameter is not a valid CFCharacterSet, the behavior is undefined.
*/
extern Boolean CFCharacterSetIsSupersetOfSet(CFCharacterSetRef theSet, CFCharacterSetRef theOtherset);

/*!
	@function CFCharacterSetHasMemberInPlane
	Reports whether or not the character set contains at least one member character in the specified plane.
	@param theSet  The character set to be checked for the membership.  If this
		parameter is not a valid CFCharacterSet, the behavior is undefined.
	@param thePlane  The plane number to be checked for the membership.
		The valid value range is from 0 to 16.  If the value is outside of the valid
		plane number range, the behavior is undefined.
*/
extern Boolean CFCharacterSetHasMemberInPlane(CFCharacterSetRef theSet, CFIndex thePlane);

/*!
	@function CFCharacterSetCreateMutable
	Creates a new empty mutable character set.
	@param alloc The CFAllocator which should be used to allocate
		memory for the array and its storage for values. This
		parameter may be NULL in which case the current default
		CFAllocator is used. If this reference is not a valid
		CFAllocator, the behavior is undefined.
	@result A reference to the new mutable CFCharacterSet.
*/
extern CFMutableCharacterSetRef CFCharacterSetCreateMutable(CFAllocatorRef alloc);

/*!
	@function CFCharacterSetCreateCopy
	Creates a new character set with the values from the given character set.  This function tries to compact the backing store where applicable.
	@param alloc The CFAllocator which should be used to allocate
		memory for the array and its storage for values. This
		parameter may be NULL in which case the current default
		CFAllocator is used. If this reference is not a valid
		CFAllocator, the behavior is undefined.
	@param theSet The CFCharacterSet which is to be copied.  If this
                parameter is not a valid CFCharacterSet, the behavior is
                undefined.
	@result A reference to the new CFCharacterSet.
*/
extern CFCharacterSetRef CFCharacterSetCreateCopy(CFAllocatorRef alloc, CFCharacterSetRef theSet);

/*!
	@function CFCharacterSetCreateMutableCopy
	Creates a new mutable character set with the values from the given character set.
	@param alloc The CFAllocator which should be used to allocate
		memory for the array and its storage for values. This
		parameter may be NULL in which case the current default
		CFAllocator is used. If this reference is not a valid
		CFAllocator, the behavior is undefined.
	@param theSet The CFCharacterSet which is to be copied.  If this
                parameter is not a valid CFCharacterSet, the behavior is
                undefined.
	@result A reference to the new mutable CFCharacterSet.
*/
extern CFMutableCharacterSetRef CFCharacterSetCreateMutableCopy(CFAllocatorRef alloc, CFCharacterSetRef theSet);

/*!
	@function CFCharacterSetIsCharacterMember
	Reports whether or not the Unicode character is in the character set.
	@param theSet The character set to be searched. If this parameter
                is not a valid CFCharacterSet, the behavior is undefined.
	@param theChar The Unicode character for which to test against the
                character set.  Note that this function takes 16-bit Unicode
                character value; hence, it does not support access to the
                non-BMP planes.  
        @result true, if the value is in the character set, otherwise false.
*/
extern Boolean CFCharacterSetIsCharacterMember(CFCharacterSetRef theSet, UniChar theChar);

/*!
	@function CFCharacterSetIsLongCharacterMember
	Reports whether or not the UTF-32 character is in the character set.
	@param theSet The character set to be searched. If this parameter
               		 is not a valid CFCharacterSet, the behavior is undefined.
	@param theChar The UTF-32 character for which to test against the
			character set.
        @result true, if the value is in the character set, otherwise false.
*/
extern Boolean CFCharacterSetIsLongCharacterMember(CFCharacterSetRef theSet, UTF32Char theChar);

/*!
	@function CFCharacterSetCreateBitmapRepresentation
	Creates a new immutable data with the bitmap representation from the given character set.
	@param alloc The CFAllocator which should be used to allocate
		memory for the array and its storage for values. This
		parameter may be NULL in which case the current default
		CFAllocator is used. If this reference is not a valid
		CFAllocator, the behavior is undefined.
	@param theSet The CFCharacterSet which is to be used create the
                bitmap representation from.  Refer to the comments for
                CFCharacterSetCreateWithBitmapRepresentation for the
                detailed discussion of the bitmap representation format.
                If this parameter is not a valid CFCharacterSet, the
                behavior is undefined.
	@result A reference to the new immutable CFData.
*/
extern CFDataRef CFCharacterSetCreateBitmapRepresentation(CFAllocatorRef alloc, CFCharacterSetRef theSet);

/*!
	@function CFCharacterSetAddCharactersInRange
	Adds the given range to the charaacter set.
	@param theSet The character set to which the range is to be added.
                If this parameter is not a valid mutable CFCharacterSet,
                the behavior is undefined.
        @param theRange The range to add to the character set.  It accepts
                the range in 32-bit in the UTF-32 format.  The valid
                character point range is from 0x00000 to 0x10FFFF.  If the
                range is outside of the valid Unicode character point,
                the behavior is undefined.
*/
extern void CFCharacterSetAddCharactersInRange(CFMutableCharacterSetRef theSet, CFRange theRange);

/*!
	@function CFCharacterSetRemoveCharactersInRange
	Removes the given range from the charaacter set.
	@param theSet The character set from which the range is to be
                removed.  If this parameter is not a valid mutable
                CFCharacterSet, the behavior is undefined.
        @param theRange The range to remove from the character set.
                It accepts the range in 32-bit in the UTF-32 format.
                The valid character point range is from 0x00000 to 0x10FFFF.
                If the range is outside of the valid Unicode character point,
                the behavior is undefined.
*/
extern void CFCharacterSetRemoveCharactersInRange(CFMutableCharacterSetRef theSet, CFRange theRange);

/*!
	@function CFCharacterSetAddCharactersInString
	Adds the characters in the given string to the charaacter set.
	@param theSet The character set to which the characters in the
                string are to be added.  If this parameter is not a
                valid mutable CFCharacterSet, the behavior is undefined.
        @param theString The string to add to the character set.
                If this parameter is not a valid CFString, the behavior
                is undefined.
*/
extern void CFCharacterSetAddCharactersInString(CFMutableCharacterSetRef theSet,  CFStringRef theString);

/*!
	@function CFCharacterSetRemoveCharactersInString
	Removes the characters in the given string from the charaacter set.
	@param theSet The character set from which the characters in the
                string are to be remove.  If this parameter is not a
                valid mutable CFCharacterSet, the behavior is undefined.
        @param theString The string to remove from the character set.
                If this parameter is not a valid CFString, the behavior
                is undefined.
*/
extern void CFCharacterSetRemoveCharactersInString(CFMutableCharacterSetRef theSet, CFStringRef theString);

/*!
	@function CFCharacterSetUnion
	Forms the union with the given character set.
	@param theSet The destination character set into which the
                union of the two character sets is stored.  If this
                parameter is not a valid mutable CFCharacterSet, the
                behavior is undefined.
	@param theOtherSet The character set with which the union is
                formed.  If this parameter is not a valid CFCharacterSet,
                the behavior is undefined.
*/
extern void CFCharacterSetUnion(CFMutableCharacterSetRef theSet, CFCharacterSetRef theOtherSet);

/*!
	@function CFCharacterSetIntersect
	Forms the intersection with the given character set.
	@param theSet The destination character set into which the
                intersection of the two character sets is stored.
                If this parameter is not a valid mutable CFCharacterSet,
                the behavior is undefined.
	@param theOtherSet The character set with which the intersection
                is formed.  If this parameter is not a valid CFCharacterSet,
                the behavior is undefined.
*/
extern void CFCharacterSetIntersect(CFMutableCharacterSetRef theSet, CFCharacterSetRef theOtherSet);

/*!
	@function CFCharacterSetInvert
	Inverts the content of the given character set.
	@param theSet The character set to be inverted.
                If this parameter is not a valid mutable CFCharacterSet,
                the behavior is undefined.
*/
extern void CFCharacterSetInvert(CFMutableCharacterSetRef theSet);