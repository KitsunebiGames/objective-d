/*
    CoreFoundation Data

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfdata;
import corefoundation.core;
import foundation.nsdata;

extern(C) @nogc nothrow:

/**
    A CoreFoundation Data Store
*/
alias CFDataRef = CFSubType!("CFData", NSData);
alias CFMutableDataRef = CFSubType!("CFMutableData", NSMutableData);

enum CFDataSearchFlags : CFOptionFlags {
    kCFDataSearchBackwards = 1UL << 0,
    kCFDataSearchAnchored = 1UL << 1
}

extern CFTypeID CFDataGetTypeID();
extern CFDataRef CFDataCreate(CFAllocatorRef allocator, const(UInt8)* bytes, CFIndex length);
extern CFDataRef CFDataCreateWithBytesNoCopy(CFAllocatorRef allocator, const(UInt8)* bytes, CFIndex length, CFAllocatorRef bytesDeallocator);
extern CFDataRef CFDataCreateCopy(CFAllocatorRef allocator, CFDataRef theData);
extern CFMutableDataRef CFDataCreateMutable(CFAllocatorRef allocator, CFIndex capacity);
extern CFMutableDataRef CFDataCreateMutableCopy(CFAllocatorRef allocator, CFIndex capacity, CFDataRef theData);
extern CFIndex CFDataGetLength(CFDataRef theData);
extern const(UInt8)* CFDataGetBytePtr(CFDataRef theData);
extern UInt8 *CFDataGetMutableBytePtr(CFMutableDataRef theData);
extern void CFDataGetBytes(CFDataRef theData, CFRange range, UInt8 *buffer); 
extern void CFDataSetLength(CFMutableDataRef theData, CFIndex length);
extern void CFDataIncreaseLength(CFMutableDataRef theData, CFIndex extraLength);
extern void CFDataAppendBytes(CFMutableDataRef theData, const(UInt8)* bytes, CFIndex length);
extern void CFDataReplaceBytes(CFMutableDataRef theData, CFRange range, const(UInt8)* newBytes, CFIndex newLength);
extern void CFDataDeleteBytes(CFMutableDataRef theData, CFRange range);
extern CFRange CFDataFind(CFDataRef theData, CFDataRef dataToFind, CFRange searchRange, CFDataSearchFlags compareOptions);
