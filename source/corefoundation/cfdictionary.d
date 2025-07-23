/**
    CoreFoundation Dictionaries

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfdictionary;
import corefoundation.cfallocator;
import corefoundation.cfstring;
import corefoundation.core;
import foundation.nsdictionary;

extern(C) @nogc nothrow:

/**
    A CoreFoundation Array
*/
alias CFDictionaryRef = CFSubType!("CFDictionary", NSDictionary);

/**
    A CoreFoundation Mutable Array
*/
alias CFMutableDictionaryRef = CFSubType!("CFMutableDictionary", NSMutableDictionary);

alias CFDictionaryRetainCallBack = const(void)*	function(CFAllocatorRef allocator, const(void)* value);
alias CFDictionaryReleaseCallBack = void function(CFAllocatorRef allocator, const(void)* value);
alias CFDictionaryCopyDescriptionCallBack = CFStringRef	function(const(void)* value);
alias CFDictionaryEqualCallBack = bool function(const(void)* value1, const(void)* value2);
alias CFDictionaryHashCallBack = CFHashCode	function(const(void)* value);

/**
	Structure containing the callbacks for keys of a CFDictionary.
*/
struct CFDictionaryKeyCallBacks {
    /**
        The version number of the structure type being passed
		in as a parameter to the CFDictionary creation functions.
		This structure is version 0.
    */
    CFIndex				version_;

    /**
        The callback used to add a retain for the dictionary
		on keys as they are used to put values into the dictionary.
		This callback returns the value to use as the key in the
		dictionary, which is usually the value parameter passed to
		this callback, but may be a different value if a different
		value should be used as the key. The dictionary's allocator
		is passed as the first argument.
    */
    CFDictionaryRetainCallBack		retain;

    /**
        The callback used to remove a retain previously added
		for the dictionary from keys as their values are removed from
		the dictionary. The dictionary's allocator is passed as the
		first argument.
    */
    CFDictionaryReleaseCallBack		release;

    /**
        The callback used to create a descriptive
		string representation of each key in the dictionary. This
		is used by the CFCopyDescription() function.
    */
    CFDictionaryCopyDescriptionCallBack	copyDescription;

    /**
        The callback used to compare keys in the dictionary for
		equality.
    */
    CFDictionaryEqualCallBack		equal;

    /**
        The callback used to compute a hash code for keys as they
		are used to access, add, or remove values in the dictionary.
    */
    CFDictionaryHashCallBack		hash;
}

/**
	Predefined CFDictionaryKeyCallBacks structure containing a
	set of callbacks appropriate for use when the keys of a
	CFDictionary are all CFTypes.
*/
extern const __gshared CFDictionaryKeyCallBacks kCFTypeDictionaryKeyCallBacks;

/**
	Predefined CFDictionaryKeyCallBacks structure containing a
	set of callbacks appropriate for use when the keys of a
	CFDictionary are all CFStrings, which may be mutable and
	need to be copied in order to serve as constant keys for
	the values in the dictionary.
*/
extern const __gshared CFDictionaryKeyCallBacks kCFCopyStringDictionaryKeyCallBacks;


/**
	Structure containing the callbacks for values of a CFDictionary.
*/
struct CFDictionaryValueCallBacks {

    /**
        The version number of the structure type being passed
		in as a parameter to the CFDictionary creation functions.
		This structure is version 0.
    */
    CFIndex				version_;

    /**
        The callback used to add a retain for the dictionary
		on values as they are put into the dictionary.
		This callback returns the value to use as the value in the
		dictionary, which is usually the value parameter passed to
		this callback, but may be a different value if a different
		value should be added to the dictionary. The dictionary's
		allocator is passed as the first argument.
    */
    CFDictionaryRetainCallBack		retain;

    /**
        The callback used to remove a retain previously added
		for the dictionary from values as they are removed from
		the dictionary. The dictionary's allocator is passed as the
		first argument.
    */
    CFDictionaryReleaseCallBack		release;

    /**
        The callback used to create a descriptive
		string representation of each value in the dictionary. This
		is used by the CFCopyDescription() function.
    */
    CFDictionaryCopyDescriptionCallBack	copyDescription;

    /**
        The callback used to compare values in the dictionary for
		equality in some operations.
    */
    CFDictionaryEqualCallBack		equal;
}

/**
	Predefined CFDictionaryValueCallBacks structure containing a set
	of callbacks appropriate for use when the values in a CFDictionary
	are all CFTypes.
*/
extern const __gshared CFDictionaryValueCallBacks kCFTypeDictionaryValueCallBacks;

/**
	Type of the callback function used by the apply functions of
    CFDictionaries.
*/
alias CFDictionaryApplierFunction = void function(const(void)* key, const(void)* value, void* context);

/**
	@function CFDictionaryGetTypeID
	Returns the type identifier of all CFDictionary instances.
*/
extern CFTypeID CFDictionaryGetTypeID();

/**
	Creates a new immutable dictionary with the given values.

	Params:
		allocator =	        The CFAllocator which should be used to allocate
                            memory for the dictionary and its storage for values. This
                            parameter may be $(D null) in which case the current default
                            CFAllocator is used. If this reference is not a valid
                            CFAllocator, the behavior is undefined.
		keys =              A C array of the pointer-sized keys to be used for
                            the parallel C array of values to be put into the dictionary.
                            This parameter may be $(D null) if the numValues parameter is 0.
                            This C array is not changed or freed by this function. If
                            this parameter is not a valid pointer to a C array of at
                            least numValues pointers, the behavior is undefined.
	    values =            A C array of the pointer-sized values to be in the
                            dictionary. This parameter may be $(D null) if the numValues
                            parameter is 0. This C array is not changed or freed by
                            this function. If this parameter is not a valid pointer to
                            a C array of at least numValues pointers, the behavior is
                            undefined.
	    numValues =         The number of values to copy from the keys and
						    values C arrays into the CFDictionary. This number will be
						    the count of the dictionary. If this parameter is
						    negative, or greater than the number of values actually
						    in the keys or values C arrays, the behavior is undefined.
		keyCallBacks =      A pointer to a CFDictionaryKeyCallBacks structure
                            initialized with the callbacks for the dictionary to use on
                            each key in the dictionary. The retain callback will be used
                            within this function, for example, to retain all of the new
                            keys from the keys C array. A copy of the contents of the
                            callbacks structure is made, so that a pointer to a structure
                            on the stack can be passed in, or can be reused for multiple
                            dictionary creations. If the version field of this
                            callbacks structure is not one of the defined ones for
                            CFDictionary, the behavior is undefined. The retain field may
                            be $(D null), in which case the CFDictionary will do nothing to add
                            a retain to the keys of the contained values. The release field
                            may be $(D null), in which case the CFDictionary will do nothing
                            to remove the dictionary's retain (if any) on the keys when the
                            dictionary is destroyed or a key-value pair is removed. If the
                            copyDescription field is $(D null), the dictionary will create a
                            simple description for a key. If the equal field is $(D null), the
                            dictionary will use pointer equality to test for equality of
                            keys. If the hash field is $(D null), a key will be converted from
                            a pointer to an integer to compute the hash code. This callbacks
                            parameter itself may be $(D null), which is treated as if a valid
                            structure of version 0 with all fields $(D null) had been passed in.
                            $(D Otherwise), if any of the fields are not valid pointers to
                            functions of the correct type, or this parameter is not a
                            valid pointer to a CFDictionaryKeyCallBacks callbacks structure,
                            the behavior is undefined. If any of the keys put into the
                            dictionary is not one understood by one of the callback functions
                            the behavior when that callback function is used is undefined.
	    valueCallBacks =	A pointer to a CFDictionaryValueCallBacks structure
                            initialized with the callbacks for the dictionary to use on
                            each value in the dictionary. The retain callback will be used
                            within this function, for example, to retain all of the new
                            values from the values C array. A copy of the contents of the
                            callbacks structure is made, so that a pointer to a structure
                            on the stack can be passed in, or can be reused for multiple
                            dictionary creations. If the version field of this callbacks
                            structure is not one of the defined ones for CFDictionary, the
                            behavior is undefined. The retain field may be $(D null), in which
                            case the CFDictionary will do nothing to add a retain to values
                            as they are put into the dictionary. The release field may be
                            $(D null), in which case the CFDictionary will do nothing to remove
                            the dictionary's retain (if any) on the values when the
                            dictionary is destroyed or a key-value pair is removed. If the
                            copyDescription field is $(D null), the dictionary will create a
                            simple description for a value. If the equal field is $(D null), the
                            dictionary will use pointer equality to test for equality of
                            values. This callbacks parameter itself may be $(D null), which is
                            treated as if a valid structure of version 0 with all fields
                            $(D null) had been passed in. Otherwise,
                            if any of the fields are not valid pointers to functions
                            of the correct type, or this parameter is not a valid
                            pointer to a CFDictionaryValueCallBacks callbacks structure,
                            the behavior is undefined. If any of the values put into the
                            dictionary is not one understood by one of the callback functions
                            the behavior when that callback function is used is undefined.
    
    Returns:
	    A reference to the new immutable CFDictionary.
*/
extern CFDictionaryRef CFDictionaryCreate(CFAllocatorRef allocator, const(void)** keys, const(void)** values, CFIndex numValues, const(CFDictionaryKeyCallBacks)* keyCallBacks, const(CFDictionaryValueCallBacks)* valueCallBacks);

/**
	Creates a new immutable dictionary with the key-value pairs from
    the given dictionary.

    Params:
	    allocator = The CFAllocator which should be used to allocate
                    memory for the dictionary and its storage for values. This
                    parameter may be $(D null) in which case the current default
                    CFAllocator is used. If this reference is not a valid
                    CFAllocator, the behavior is undefined.
	    theDict =   The dictionary which is to be copied. The keys and values
                    from the dictionary are copied as pointers into the new
                    dictionary (that is, the values themselves are copied, not
                    that which the values point $(D to), if anything). However, the
                    keys and values are also retained by the new dictionary using
                    the retain function of the original dictionary.
                    The count of the new dictionary will be the same as the
                    given dictionary. The new dictionary uses the same callbacks
                    as the dictionary to be copied. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
	
    Returns:
        A reference to the new immutable CFDictionary.
*/
extern CFDictionaryRef CFDictionaryCreateCopy(CFAllocatorRef allocator, CFDictionaryRef theDict);

/**
	Creates a new mutable dictionary.
	
    Params:
        allocator =         The CFAllocator which should be used to allocate
                            memory for the dictionary and its storage for values. This
                            parameter may be $(D null) in which case the current default
                            CFAllocator is used. If this reference is not a valid
                            CFAllocator, the behavior is undefined.
        capacity =          A hint about the number of values that will be held
                            by the CFDictionary. Pass 0 for no hint. The implementation may
                            ignore this hint, or may use it to optimize various
                            operations. (A dictionary's actual capacity is only limited by 
                            address space and available memory constraints). If this 
                            parameter is negative, the behavior is undefined.
	    keyCallBacks =      A pointer to a CFDictionaryKeyCallBacks structure
                            initialized with the callbacks for the dictionary to use on
                            each key in the dictionary. A copy of the contents of the
                            callbacks structure is made, so that a pointer to a structure
                            on the stack can be passed in, or can be reused for multiple
                            dictionary creations. If the version field of this
                            callbacks structure is not one of the defined ones for
                            CFDictionary, the behavior is undefined. The retain field may
                            be $(D null), in which case the CFDictionary will do nothing to add
                            a retain to the keys of the contained values. The release field
                            may be $(D null), in which case the CFDictionary will do nothing
                            to remove the dictionary's retain (if any) on the keys when the
                            dictionary is destroyed or a key-value pair is removed. If the
                            copyDescription field is $(D null), the dictionary will create a
                            simple description for a key. If the equal field is $(D null), the
                            dictionary will use pointer equality to test for equality of
                            keys. If the hash field is $(D null), a key will be converted from
                            a pointer to an integer to compute the hash code. This callbacks
                            parameter itself may be $(D null), which is treated as if a valid
                            structure of version 0 with all fields $(D null) had been passed in.
                            $(D Otherwise), if any of the fields are not valid pointers to
                            functions of the correct type, or this parameter is not a
                            valid pointer to a CFDictionaryKeyCallBacks callbacks structure,
                            the behavior is undefined. If any of the keys put into the
                            dictionary is not one understood by one of the callback functions
                            the behavior when that callback function is used is undefined.
	    valueCallBacks =    A pointer to a CFDictionaryValueCallBacks structure
                            initialized with the callbacks for the dictionary to use on
                            each value in the dictionary. The retain callback will be used
                            within this function, for example, to retain all of the new
                            values from the values C array. A copy of the contents of the
                            callbacks structure is made, so that a pointer to a structure
                            on the stack can be passed in, or can be reused for multiple
                            dictionary creations. If the version field of this callbacks
                            structure is not one of the defined ones for CFDictionary, the
                            behavior is undefined. The retain field may be $(D null), in which
                            case the CFDictionary will do nothing to add a retain to values
                            as they are put into the dictionary. The release field may be
                            $(D null), in which case the CFDictionary will do nothing to remove
                            the dictionary's retain (if any) on the values when the
                            dictionary is destroyed or a key-value pair is removed. If the
                            copyDescription field is $(D null), the dictionary will create a
                            simple description for a value. If the equal field is $(D null), the
                            dictionary will use pointer equality to test for equality of
                            values. This callbacks parameter itself may be $(D null), which is
                            treated as if a valid structure of version 0 with all fields
                            $(D null) had been passed in. Otherwise,
                            if any of the fields are not valid pointers to functions
                            of the correct type, or this parameter is not a valid
                            pointer to a CFDictionaryValueCallBacks callbacks structure,
                            the behavior is undefined. If any of the values put into the
                            dictionary is not one understood by one of the callback functions
                            the behavior when that callback function is used is undefined.
    
    Returns:
	    A reference to the new mutable CFDictionary.
*/
extern CFMutableDictionaryRef CFDictionaryCreateMutable(CFAllocatorRef allocator, CFIndex capacity, const(CFDictionaryKeyCallBacks)* keyCallBacks, const(CFDictionaryValueCallBacks)* valueCallBacks);

/**
	Creates a new mutable dictionary with the key-value pairs from
    the given dictionary.

    Params:
        allocator = The CFAllocator which should be used to allocate
                    memory for the dictionary and its storage for values. This
                    parameter may be $(D null) in which case the current default
                    CFAllocator is used. If this reference is not a valid
                    CFAllocator, the behavior is undefined.
        capacity =  A hint about the number of values that will be held
                    by the CFDictionary. Pass 0 for no hint. The implementation may
                    ignore this hint, or may use it to optimize various
                    operations. (A dictionary's actual capacity is only limited by
                    address space and available memory constraints). 
                    This parameter must be greater than or equal
                    to the count of the dictionary which is to be copied, or the
                    behavior is undefined. If this parameter is negative, the
                    behavior is undefined.
        theDict =   The dictionary which is to be copied. The keys and values
                    from the dictionary are copied as pointers into the new
                    dictionary (that is, the values themselves are copied, not
                    that which the values point $(D to), if anything). However, the
                    keys and values are also retained by the new dictionary using
                    the retain function of the original dictionary.
                    The count of the new dictionary will be the same as the
                    given dictionary. The new dictionary uses the same callbacks
                    as the dictionary to be copied. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
	
    Returns:
        A reference to the new mutable CFDictionary.
*/
extern CFMutableDictionaryRef CFDictionaryCreateMutableCopy(CFAllocatorRef allocator, CFIndex capacity, CFDictionaryRef theDict);

/**
	Returns the number of values currently in the dictionary.

    Params:
        theDict =   The dictionary to be queried. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
	
    Returns:
        The number of values in the dictionary.
*/
extern CFIndex CFDictionaryGetCount(CFDictionaryRef theDict);

/**
	Counts the number of times the given key occurs in the dictionary.

    Params:
        theDict =   The dictionary to be searched. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        key =       The key for which to find matches in the dictionary. The
                    hash() and equal() key callbacks provided when the dictionary
                    was created are used to compare. If the hash() key callback
                    was $(D null), the key is treated as a pointer and converted to
                    an integer. If the equal() key callback was $(D null), pointer
                    equality (in C, ==) is used. If key, or any of the keys in
                    the dictionary, are not understood by the equal() callback,
                    the behavior is undefined.
    
    Returns:
	    1 if a matching key is used by the dictionary, 0 otherwise.
*/
extern CFIndex CFDictionaryGetCountOfKey(CFDictionaryRef theDict, const(void)* key);

/**
	Counts the number of times the given value occurs in the dictionary.

    Params:
        theDict =   The dictionary to be searched. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        value =     The value for which to find matches in the dictionary. The
                    equal() callback provided when the dictionary was created is
                    used to compare. If the equal() value callback was $(D null), pointer
                    equality (in C, ==) is used. If value, or any of the values in
                    the dictionary, are not understood by the equal() callback,
                    the behavior is undefined.
	
    Returns:
        The number of times the given value occurs in the dictionary.
*/
extern CFIndex CFDictionaryGetCountOfValue(CFDictionaryRef theDict, const(void)* value);

/**
	Reports whether or not the key is in the dictionary.

    Params:
        theDict =   The dictionary to be searched. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        key =       The key for which to find matches in the dictionary. The
                    hash() and equal() key callbacks provided when the dictionary
                    was created are used to compare. If the hash() key callback
                    was $(D null), the key is treated as a pointer and converted to
                    an integer. If the equal() key callback was $(D null), pointer
                    equality (in C, ==) is used. If key, or any of the keys in
                    the dictionary, are not understood by the equal() callback,
                    the behavior is undefined.
	
    Returns:
        $(D true), if the key is in the dictionary, otherwise $(D false).
*/
extern bool CFDictionaryContainsKey(CFDictionaryRef theDict, const(void)* key);

/**
	Reports whether or not the value is in the dictionary.

    Params:
        theDict =   The dictionary to be searched. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        value =     The value for which to find matches in the dictionary. The
                    equal() callback provided when the dictionary was created is
                    used to compare. If the equal() callback was $(D null), pointer
                    equality (in C, ==) is used. If value, or any of the values
                    in the dictionary, are not understood by the equal() callback,
                    the behavior is undefined.
	
    Returns:
        $(D true), if the value is in the dictionary, otherwise $(D false).
*/
extern bool CFDictionaryContainsValue(CFDictionaryRef theDict, const(void)* value);

/**
	Retrieves the value associated with the given key.

    Params:
        theDict =   The dictionary to be queried. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        key =       The key for which to find a match in the dictionary. The
                    hash() and equal() key callbacks provided when the dictionary
                    was created are used to compare. If the hash() key callback
                    was $(D null), the key is treated as a pointer and converted to
                    an integer. If the equal() key callback was $(D null), pointer
                    equality (in C, ==) is used. If key, or any of the keys in
                    the dictionary, are not understood by the equal() callback,
                    the behavior is undefined.
    
    @result The value with the given key in the dictionary, or $(D null) if
        no key-value pair with a matching key exists. Since $(D null)
        can be a valid value in some dictionaries, the function
        CFDictionaryGetValueIfPresent() must be used to distinguish
        $(D null)-no-found from $(D null)-is-the-value.
*/
extern const(void)* CFDictionaryGetValue(CFDictionaryRef theDict, const(void)* key);

/**
	Retrieves the value associated with the given key.

    Params:
        theDict =   The dictionary to be queried. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        key =       The key for which to find a match in the dictionary. The
                    hash() and equal() key callbacks provided when the dictionary
                    was created are used to compare. If the hash() key callback
                    was $(D null), the key is treated as a pointer and converted to
                    an integer. If the equal() key callback was $(D null), pointer
                    equality (in C, ==) is used. If key, or any of the keys in
                    the dictionary, are not understood by the equal() callback,
                    the behavior is undefined.
        value =     A pointer to memory which should be filled with the
                    pointer-sized value if a matching key is found. If no key
                    match is found, the contents of the storage pointed to by
                    this parameter are undefined. This parameter may be $(D null),
                    in which case the value from the dictionary is not returned
                    (but the return value of this function still indicates
                    whether or not the key-value pair was present).
	
    Returns:
        $(D true), if a matching key was found, false otherwise.
*/
extern bool CFDictionaryGetValueIfPresent(CFDictionaryRef theDict, const(void)* key, const(void)** value);

/**
	Fills the two buffers with the keys and values from the dictionary.

    Params:
        theDict =   The dictionary to be queried. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        keys =      A C array of pointer-sized values to be filled with keys
                    from the dictionary. The keys and values C arrays are parallel
                    to each other (that is, the items at the same indices form a
                    key-value pair from the dictionary). This parameter may be $(D null)
                    if the keys are not desired. If this parameter is not a valid
                    pointer to a C array of at least CFDictionaryGetCount() pointers,
                    or $(D null), the behavior is undefined.
        values =    A C array of pointer-sized values to be filled with values
                    from the dictionary. The keys and values C arrays are parallel
                    to each other (that is, the items at the same indices form a
                    key-value pair from the dictionary). This parameter may be $(D null)
                    if the values are not desired. If this parameter is not a valid
                    pointer to a C array of at least CFDictionaryGetCount() pointers,
                    or $(D null), the behavior is undefined.
*/
extern void CFDictionaryGetKeysAndValues(CFDictionaryRef theDict, const(void)** keys, const(void)** values);

/**
	Calls a function once for each value in the dictionary.

    Params:
        theDict =   The dictionary to be queried. If this parameter is
                    not a valid CFDictionary, the behavior is undefined.
        applier =   The callback function to call once for each value in
                    the dictionary. If this parameter is not a
                    pointer to a function of the correct prototype, the behavior
                    is undefined. If there are keys or values which the
                    applier function does not expect or cannot properly apply
                    to, the behavior is undefined. 
        context =   A pointer-sized user-defined value, which is passed
                    as the third parameter to the applier function, but is
                    otherwise $(D unused) by this function. If the context is not
                    what is expected by the applier function, the behavior is
                    undefined.
*/
extern void CFDictionaryApplyFunction(CFDictionaryRef theDict, CFDictionaryApplierFunction applier, void* context);

/**
	Adds the key-value pair to the dictionary if no such key already exists.

    Params:
        theDict =   The dictionary to which the value is to be added. If this
                    parameter is not a valid mutable CFDictionary, the behavior is
                    undefined.
        key =       The key of the value to add to the dictionary. The key is
                    retained by the dictionary using the retain callback provided
                    when the dictionary was created. If the key is not of the sort
                    expected by the retain callback, the behavior is undefined. If
                    a key which matches this key is already present in the dictionary,
                    this function does nothing ("add if absent").
        value =     The value to add to the dictionary. The value is retained
                    by the dictionary using the retain callback provided when the
                    dictionary was created. If the value is not of the sort expected
                    by the retain callback, the behavior is undefined.
*/
extern void CFDictionaryAddValue(CFMutableDictionaryRef theDict, const(void)* key, const(void)* value);

/**
	Sets the value of the key in the dictionary.

    Params:
        theDict =   The dictionary to which the value is to be set. If this
                    parameter is not a valid mutable CFDictionary, the behavior is
                    undefined.
        key =       The key of the value to set into the dictionary. If a key 
                    which matches this key is already present in the dictionary, only
                    the value is changed ("add if absent, replace if present"). If
                    no key matches the given key, the key-value pair is added to the
                    dictionary. If added, the key is retained by the dictionary,
                    using the retain callback provided
                    when the dictionary was created. If the key is not of the sort
                    expected by the key retain callback, the behavior is undefined.
        value =     The value to add to or replace into the dictionary. The value
                    is retained by the dictionary using the retain callback provided
                    when the dictionary was created, and the previous value if any is
                    released. If the value is not of the sort expected by the
                    retain or release callbacks, the behavior is undefined.
*/
extern void CFDictionarySetValue(CFMutableDictionaryRef theDict, const(void)* key, const(void)* value);

/**
	Replaces the value of the key in the dictionary.

    Params:
        theDict =   The dictionary to which the value is to be replaced. If this
                    parameter is not a valid mutable CFDictionary, the behavior is
                    undefined.
        key =       The key of the value to replace in the dictionary. If a key 
                    which matches this key is present in the dictionary, the value
                    is changed to the given value, otherwise $(D this) function does
                    nothing ("replace if present").
        value =     The value to replace into the dictionary. The value
                    is retained by the dictionary using the retain callback provided
                    when the dictionary was created, and the previous value is
                    released. If the value is not of the sort expected by the
                    retain or release callbacks, the behavior is undefined.
*/
extern void CFDictionaryReplaceValue(CFMutableDictionaryRef theDict, const(void)* key, const(void)* value);

/**
	Removes the value of the key from the dictionary.
    
    Params:
        theDict =   The dictionary from which the value is to be removed. If this
                    parameter is not a valid mutable CFDictionary, the behavior is
                    undefined.
        key =       The key of the value to remove from the dictionary. If a key 
                    which matches this key is present in the dictionary, the key-value
                    pair is removed from the dictionary, otherwise $(D this) function does
                    nothing ("remove if present").
*/
extern void CFDictionaryRemoveValue(CFMutableDictionaryRef theDict, const(void)* key);

/**
	Removes all the values from the dictionary, making it empty.

    Params:
        theDict =   The dictionary from which all of the values are to be
                    removed. If this parameter is not a valid mutable
                    CFDictionary, the behavior is undefined.
*/
extern void CFDictionaryRemoveAllValues(CFMutableDictionaryRef theDict);