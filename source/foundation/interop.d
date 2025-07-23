/**
    Helpful Interop functionality for Foundation

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module foundation.interop;

/**
    Converts a basic type to a retained Foundation type.

    Params:
        value = The value to convert
    
    Returns:
        The converted value.
*/
auto ns(T)(T value) @nogc {
    static if (is(T : string)) {
        
        import foundation.nsstring : NSString;
        return NSString.create(value);
    } else static if (__traits(isScalar, T)) {
        
        import foundation.nsvalue : NSNumber;
        return NSNumber.create(value);
    } else static if (is(T : ubyte[]) || is (T == void[])) {

        import foundation.nsdata : NSData;
        return NSData.create(value.ptr, value.length);
    } else static assert(0, T.stringof~" is not a basic D type.");
}

// Tests that all .ns conversions convert to the correct types.
@("ns")
unittest {
    import foundation.nsstring : NSString;
    import foundation.nsvalue : NSNumber;
    import foundation.nsdata : NSData;
    
    assert(("Hello, world!".ns()).isCompatibleWith(NSString.class_));
    assert(((cast(byte)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(short)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(int)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(long)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(ubyte)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(ushort)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(uint)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(ulong)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(float)1).ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(double)1).ns()).isCompatibleWith(NSNumber.class_));
    assert((true.ns()).isCompatibleWith(NSNumber.class_));
    assert(((cast(ubyte[])[0x0, 0x0, 0x0, 0x0]).ns()).isCompatibleWith(NSData.class_));
}