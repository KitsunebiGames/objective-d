/*
    CoreFoundation Arrays

    Copyright: Copyright © 2024-2025, Kitsunebi Games EMV
    License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
    Authors:   Luna Nielsen
*/
module corefoundation.cfarray;
import corefoundation.cfallocator;
import corefoundation.cfstring;
import corefoundation.core;
import foundation.nsarray;

extern(C) @nogc nothrow:

/**
    A CoreFoundation Array
*/
@objd_bridge!(CFArrayRef, NSArray)
alias CFArrayRef = CFSubType!("CFArray");

/**
    A CoreFoundation Mutable Array
*/
@objd_bridge!(CFMutableArrayRef, NSMutableArray)
alias CFMutableArrayRef = CFSubType!("CFMutableArray");

/**
	Prototype of a callback function that may be applied to every value in an array.
*/
alias CFArrayApplierFunction = extern(C) void function(const(void)* value, const(void)* context) @nogc nothrow;

/**
	Prototype of a callback function used to retain a value being added to an array. 
*/
alias CFArrayRetainCallBack = extern(C) const(void)* function(CFAllocatorRef allocator, const(void)* value) @nogc nothrow;

/**
	Prototype of a callback function used to release a value before it’s removed from an array.
*/
alias CFArrayReleaseCallBack = extern(C) void	function(CFAllocatorRef allocator, const(void)* value) @nogc nothrow;

/**
	Prototype of a callback function used to determine if two values in an array are equal.
*/
alias CFArrayEqualCallBack = extern(C) bool function(const(void)* value1, const(void)* value2) @nogc nothrow;

/**
	Prototype of a callback function used to get a description of a value in an array.
*/
alias CFArrayCopyDescriptionCallBack = extern(C) CFStringRef function(const(void)* value) @nogc nothrow;

/**
	Structure containing the callbacks of a CFArray.
*/
struct CFArrayCallBacks {

    /**
        The version number of the structure type being passed
		in as a parameter to the CFArray creation functions. This
		structure is version 0.
    */
    CFIndex				version_;
    
    /**
        The callback used to add a retain for the array on
		values as they are put into the array. This callback returns
		the value to store in the array, which is usually the value
		parameter passed to this callback, but may be a different
		value if a different value should be stored in the array.
		The array's allocator is passed as the first argument.
    */
    CFArrayRetainCallBack		retain;
    
    /**
        The callback used to remove a retain previously added
		for the array from values as they are removed from the
		array. The array's allocator is passed as the first
		argument.
    */
    CFArrayReleaseCallBack		release;
    
    /**
        The callback used to create a descriptive
		string representation of each value in the array. This is
		used by the CFCopyDescription() function.
    */
    CFArrayCopyDescriptionCallBack	copyDescription;
    
    /**
        The callback used to compare values in the array for
		equality for some operations.
    */
    CFArrayEqualCallBack		equal;
}

/**
    Returns the type identifier of all CFArray instances.
*/
extern CFTypeID CFArrayGetTypeID();

/**
	Creates a new immutable array with the given values.

	Params:
		allocator = The CFAllocator which should be used to allocate
					memory for the array and its storage for values. This
					parameter may be NULL in which case the current default
					CFAllocator is used. If this reference is not a valid
					CFAllocator, the behavior is undefined.
		values =  	A C array of the pointer-sized values to be in the
					array. The values in the array are ordered in the same order
					in which they appear in this C array. This parameter may be
					NULL if the numValues parameter is 0. This C array is not
					changed or freed by this function. If this parameter is not
					a valid pointer to a C array of at least numValues pointers,
					the behavior is undefined.
		numValues = The number of values to copy from the values C
					array into the CFArray. This number will be the count of the
					array.
					If this parameter is negative, or greater than the number of
					values actually in the value's C array, the behavior is
					undefined.
		callBacks = A pointer to a CFArrayCallBacks structure
					initialized with the callbacks for the array to use on each
					value in the array. The retain callback will be used within
					this function, for example, to retain all of the new values
					from the values C array. A copy of the contents of the
					callbacks structure is made, so that a pointer to a
					structure on the stack can be passed in, or can be reused
					for multiple array creations. If the version field of this
					callbacks structure is not one of the defined ones for
					CFArray, the behavior is undefined. The retain field may be
					NULL, in which case the CFArray will do nothing to add a
					retain to the contained values for the array. The release
					field may be NULL, in which case the CFArray will do nothing
					to remove the array's retain (if any) on the values when the
					array is destroyed. If the copyDescription field is NULL,
					the array will create a simple description for the value. If
					the equal field is NULL, the array will use pointer equality
					to test for equality of values. This callbacks parameter
					itself may be NULL, which is treated as if a valid structure
					of version 0 with all fields NULL had been passed in.
					Otherwise, if any of the fields are not valid pointers to
					functions of the correct type, or this parameter is not a
					valid pointer to a  CFArrayCallBacks callbacks structure,
					the behavior is undefined. If any of the values put into the
					array is not one understood by one of the callback functions
					the behavior when that callback function is used is
					undefined.

    Returns:
        A reference to the new immutable CFArray.
*/
extern CFArrayRef CFArrayCreate(CFAllocatorRef allocator, const(void)** values, CFIndex numValues, const(CFArrayCallBacks)* callBacks);


/**
	Creates a new immutable array with the values from the given array.

	Params:
		allocator = The CFAllocator which should be used to allocate
					memory for the array and its storage for values. This
					parameter may be NULL in which case the current default
					CFAllocator is used. If this reference is not a valid
					CFAllocator, the behavior is undefined.
		theArray =  The array which is to be copied. The values from the
					array are copied as pointers into the new array (that is,
					the values themselves are copied, not that which the values
					point to, if anything). However, the values are also
					retained by the new array. The count of the new array will
					be the same as the given array. The new array uses the same
					callbacks as the array to be copied. If this parameter is
					not a valid CFArray, the behavior is undefined.

    Returns:
        A reference to the new immutable CFArray.
*/
extern CFArrayRef CFArrayCreateCopy(CFAllocatorRef allocator, CFArrayRef theArray);

/**
	Creates a new empty mutable array.

	Params:
		allocator = The CFAllocator which should be used to allocate
					memory for the array and its storage for values. This
					parameter may be NULL in which case the current default
					CFAllocator is used. If this reference is not a valid
					CFAllocator, the behavior is undefined.
		capacity =  A hint about the number of values that will be held
					by the CFArray. Pass 0 for no hint. The implementation may
					ignore this hint, or may use it to optimize various
					operations. (An array's actual capacity is only limited by
					address space and available memory constraints). If this
					parameter is negative, the behavior is undefined.
		callBacks = A pointer to a CFArrayCallBacks structure
					initialized with the callbacks for the array to use on each
					value in the array. A copy of the contents of the
					callbacks structure is made, so that a pointer to a
					structure on the stack can be passed in, or can be reused
					for multiple array creations. If the version field of this
					callbacks structure is not one of the defined ones for
					CFArray, the behavior is undefined. The retain field may be
					NULL, in which case the CFArray will do nothing to add a
					retain to the contained values for the array. The release
					field may be NULL, in which case the CFArray will do nothing
					to remove the array's retain (if any) on the values when the
					array is destroyed. If the copyDescription field is NULL,
					the array will create a simple description for the value. If
					the equal field is NULL, the array will use pointer equality
					to test for equality of values. This callbacks parameter
					itself may be NULL, which is treated as if a valid structure
					of version 0 with all fields NULL had been passed in.
					Otherwise, if any of the fields are not valid pointers to
					functions of the correct type, or this parameter is not a
					valid pointer to a CFArrayCallBacks callbacks structure,
					the behavior is undefined. If any of the values put into the
					array is not one understood by one of the callback functions
					the behavior when that callback function is used is
					undefined.

    Returns:
        A reference to the new mutable CFArray.
*/
extern CFMutableArrayRef CFArrayCreateMutable(CFAllocatorRef allocator, CFIndex capacity, const(CFArrayCallBacks)* callBacks);

/**
	Creates a new mutable array with the values from the given array.

	Params:
		allocator = The CFAllocator which should be used to allocate
					memory for the array and its storage for values. This
					parameter may be NULL in which case the current default
					CFAllocator is used. If this reference is not a valid
					CFAllocator, the behavior is undefined.
		capacity =  A hint about the number of values that will be held
					by the CFArray. Pass 0 for no hint. The implementation may
					ignore this hint, or may use it to optimize various
					operations. (An array's actual capacity is only limited by 
					address space and available memory constraints).
					This parameter must be greater than or equal
					to the count of the array which is to be copied, or the
					behavior is undefined. If this parameter is negative, the
					behavior is undefined.
		theArray =  The array which is to be copied. The values from the
					array are copied as pointers into the new array (that is,
					the values themselves are copied, not that which the values
					point to, if anything). However, the values are also
					retained by the new array. The count of the new array will
					be the same as the given array. The new array uses the same
					callbacks as the array to be copied. If this parameter is
					not a valid CFArray, the behavior is undefined.

    Returns:
        A reference to the new mutable CFArray.
*/
extern CFMutableArrayRef CFArrayCreateMutableCopy(CFAllocatorRef allocator, CFIndex capacity, CFArrayRef theArray);

/**
	Returns the number of values currently in the array.
	theArray =  The array to be queried. If this parameter is not a valid
		CFArray, the behavior is undefined.

    Returns:
        The number of values in the array.
*/
extern CFIndex CFArrayGetCount(CFArrayRef theArray);

/**
	Counts the number of times the given value occurs in the array.

	Params:
		theArray =  The array to be searched. If this parameter is not a
					valid CFArray, the behavior is undefined.
		range = 	The range within the array to search. If the range
					location or end point (defined by the location plus length
					minus 1) is outside the index space of the array (0 to
					N-1 inclusive, where N is the count of the array), the
					behavior is undefined. If the range length is negative, the
					behavior is undefined. The range may be empty (length 0).
		value = 	The value for which to find matches in the array. The
					equal() callback provided when the array was created is
					used to compare. If the equal() callback was NULL, pointer
					equality (in C, ==) is used. If value, or any of the values
					in the array, are not understood by the equal() callback,
					the behavior is undefined.

    Returns:
        The number of times the given value occurs in the array,
		within the specified range.
*/
extern CFIndex CFArrayGetCountOfValue(CFArrayRef theArray, CFRange range, const(void)* value);

/**
	Reports whether or not the value is in the array.

	Params:
		theArray =  The array to be searched. If this parameter is not a
					valid CFArray, the behavior is undefined.
		range =  	The range within the array to search. If the range
					location or end point (defined by the location plus length
					minus 1) is outside the index space of the array (0 to
					N-1 inclusive, where N is the count of the array), the
					behavior is undefined. If the range length is negative, the
					behavior is undefined. The range may be empty (length 0).
		value =  	The value for which to find matches in the array. The
					equal() callback provided when the array was created is
					used to compare. If the equal() callback was NULL, pointer
					equality (in C, ==) is used. If value, or any of the values
					in the array, are not understood by the equal() callback,
					the behavior is undefined.

    Returns:
        true, if the value is in the specified range of the array,
		otherwise false.
*/
extern bool CFArrayContainsValue(CFArrayRef theArray, CFRange range, const(void)* value);

/**
	Retrieves the value at the given index.

	Params:
		theArray =  The array to be queried. If this parameter is not a
					valid CFArray, the behavior is undefined.
		idx =  		The index of the value to retrieve. If the index is
					outside the index space of the array (0 to N-1 inclusive,
					where N is the count of the array), the behavior is
					undefined.

    Returns:
        The value with the given index in the array.
*/
extern const(void)* CFArrayGetValueAtIndex(CFArrayRef theArray, CFIndex idx);

/**
	Fills the buffer with values from the array.

	Params:
		theArray =  The array to be queried. If this parameter is not a
					valid CFArray, the behavior is undefined.
		range =  	The range of values within the array to retrieve. If
					the range location or end point (defined by the location
					plus length minus 1) is outside the index space of the
					array (0 to N-1 inclusive, where N is the count of the
					array), the behavior is undefined. If the range length is
					negative, the behavior is undefined. The range may be empty
					(length 0), in which case no values are put into the buffer.
		values =  	A C array of pointer-sized values to be filled with
					values from the array. The values in the C array are ordered
					in the same order in which they appear in the array. If this
					parameter is not a valid pointer to a C array of at least
					range.length pointers, the behavior is undefined.
*/
extern void CFArrayGetValues(CFArrayRef theArray, CFRange range, const(void)** values);

/**
	Calls a function once for each value in the array.

	Params:
		theArray =  The array to be operated upon. If this parameter is not
					a valid CFArray, the behavior is undefined.
		range =  	The range of values within the array to which to apply
					the function. If the range location or end point (defined by
					the location plus length minus 1) is outside the index
					space of the array (0 to N-1 inclusive, where N is the count
					of the array), the behavior is undefined. If the range
					length is negative, the behavior is undefined. The range may
					be empty (length 0).
		applier =  	The callback function to call once for each value in
					the given range in the array. If this parameter is not a
					pointer to a function of the correct prototype, the behavior
					is undefined. If there are values in the range which the
					applier function does not expect or cannot properly apply
					to, the behavior is undefined. 
		context =  	A pointer-sized user-defined value, which is passed
					as the second parameter to the applier function, but is
					otherwise unused by this function. If the context is not
					what is expected by the applier function, the behavior is
					undefined.
*/
extern void CFArrayApplyFunction(CFArrayRef theArray, CFRange range, CFArrayApplierFunction applier, void* context);

/**
	Searches the array for the value.

	Params:
		theArray =  The array to be searched. If this parameter is not a
					valid CFArray, the behavior is undefined.
		range =  	The range within the array to search. If the range
					location or end point (defined by the location plus length
					minus 1) is outside the index space of the array (0 to
					N-1 inclusive, where N is the count of the array), the
					behavior is undefined. If the range length is negative, the
					behavior is undefined. The range may be empty (length 0).
					The search progresses from the smallest index defined by
					the range to the largest.
		value =  	The value for which to find a match in the array. The
					equal() callback provided when the array was created is
					used to compare. If the equal() callback was NULL, pointer
					equality (in C, ==) is used. If value, or any of the values
					in the array, are not understood by the equal() callback,
					the behavior is undefined.

    Returns:
        The lowest index of the matching values in the range, or
		kCFNotFound if no value in the range matched.
*/
extern CFIndex CFArrayGetFirstIndexOfValue(CFArrayRef theArray, CFRange range, const(void)* value);

/**
	Searches the array for the value.

	Params:
		theArray =  The array to be searched. If this parameter is not a
					valid CFArray, the behavior is undefined.
		range =  	The range within the array to search. If the range
					location or end point (defined by the location plus length
					minus 1) is outside the index space of the array (0 to
					N-1 inclusive, where N is the count of the array), the
					behavior is undefined. If the range length is negative, the
					behavior is undefined. The range may be empty (length 0).
					The search progresses from the largest index defined by the
					range to the smallest.
		value =  	The value for which to find a match in the array. The
					equal() callback provided when the array was created is
					used to compare. If the equal() callback was NULL, pointer
					equality (in C, ==) is used. If value, or any of the values
					in the array, are not understood by the equal() callback,
					the behavior is undefined.

    Returns:
        The highest index of the matching values in the range, or
		kCFNotFound if no value in the range matched.
*/
extern CFIndex CFArrayGetLastIndexOfValue(CFArrayRef theArray, CFRange range, const(void)* value);

/**
	Searches the array for the value using a binary search algorithm.

	Params:
		theArray =  	The array to be searched. If this parameter is not a
						valid CFArray, the behavior is undefined. If the array is
						not sorted from least to greatest according to the
						comparator function, the behavior is undefined.
		range =  		The range within the array to search. If the range
						location or end point (defined by the location plus length
						minus 1) is outside the index space of the array (0 to
						N-1 inclusive, where N is the count of the array), the
						behavior is undefined. If the range length is negative, the
						behavior is undefined. The range may be empty (length 0).
		value =  		The value for which to find a match in the array. If
						value, or any of the values in the array, are not understood
						by the comparator callback, the behavior is undefined.
		comparator =  	The function with the comparator function type
						signature which is used in the binary search operation to
						compare values in the array with the given value. If this
						parameter is not a pointer to a function of the correct
						prototype, the behavior is undefined. If there are values
						in the range which the comparator function does not expect
						or cannot properly compare, the behavior is undefined.
		context =  		A pointer-sized user-defined value, which is passed
						as the third parameter to the comparator function, but is
						otherwise unused by this function. If the context is not
						what is expected by the comparator function, the behavior is
						undefined.

    Returns:
        The return value is either
			1. 	the index of a value that matched, if the target value 
			   	matches one or more in the range,
			2. 	greater than or equal to the end point of the range, 
				if the value is greater than all the values in the range, or
			3.	the index of the value greater than the target value, 
				if the value lies between two of (or less than all of) the 
				values in the range.
*/
extern CFIndex CFArrayBSearchValues(CFArrayRef theArray, CFRange range, const(void)* value, CFComparatorFunction comparator, void* context);

/**
	Adds the value to the array giving it a new largest index.

	Params:
		theArray =  The array to which the value is to be added. If this
					parameter is not a valid mutable CFArray, the behavior is
					undefined.
		value =  	The value to add to the array. The value is retained by
					the array using the retain callback provided when the array
					was created. If the value is not of the sort expected by the
					retain callback, the behavior is undefined. The value is
					assigned to the index one larger than the previous largest
					index, and the count of the array is increased by one.
*/
extern void CFArrayAppendValue(CFMutableArrayRef theArray, const(void)* value);

/**
	Adds the value to the array, giving it the given index.

	Params:
		theArray =  The array to which the value is to be added. If this
					parameter is not a valid mutable CFArray, the behavior is
					undefined.
		idx =  		The index to which to add the new value. If the index is
					outside the index space of the array (0 to N inclusive,
					where N is the count of the array before the operation), the
					behavior is undefined. If the index is the same as N, this
					function has the same effect as CFArrayAppendValue().
		value =  	The value to add to the array. The value is retained by
					the array using the retain callback provided when the array
					was created. If the value is not of the sort expected by the
					retain callback, the behavior is undefined. The value is
					assigned to the given index, and all values with equal and
					larger indices have their indexes increased by one.
*/
extern void CFArrayInsertValueAtIndex(CFMutableArrayRef theArray, CFIndex idx, const(void)* value);

/**
	Changes the value with the given index in the array.

	Params:
		theArray =  The array in which the value is to be changed. If this
					parameter is not a valid mutable CFArray, the behavior is
					undefined.
		idx =  		The index to which to set the new value. If the index is
					outside the index space of the array (0 to N inclusive,
					where N is the count of the array before the operation), the
					behavior is undefined. If the index is the same as N, this
					function has the same effect as CFArrayAppendValue().
		value =  	The value to set in the array. The value is retained by
					the array using the retain callback provided when the array
					was created, and the previous value with that index is
					released. If the value is not of the sort expected by the
					retain callback, the behavior is undefined. The indices of
					other values is not affected.
*/
extern void CFArraySetValueAtIndex(CFMutableArrayRef theArray, CFIndex idx, const(void)* value);

/**
	Removes the value with the given index from the array.

	Params:
		theArray =  The array from which the value is to be removed. If
					this parameter is not a valid mutable CFArray, the behavior
					is undefined.
		idx =  		The index from which to remove the value. If the index is
					outside the index space of the array (0 to N-1 inclusive,
					where N is the count of the array before the operation), the
					behavior is undefined.
*/
extern void CFArrayRemoveValueAtIndex(CFMutableArrayRef theArray, CFIndex idx);

/**
	Removes all the values from the array, making it empty.

	Params:
		theArray =  The array from which all of the values are to be
					removed. If this parameter is not a valid mutable CFArray,
					the behavior is undefined.
*/
extern void CFArrayRemoveAllValues(CFMutableArrayRef theArray);

/**
	Replaces a range of values in the array.

	Params:
		theArray =  The array from which all of the values are to be
					removed. If this parameter is not a valid mutable CFArray,
					the behavior is undefined.
		range =  	The range of values within the array to replace. If the
					range location or end point (defined by the location plus
					length minus 1) is outside the index space of the array (0
					to N inclusive, where N is the count of the array), the
					behavior is undefined. If the range length is negative, the
					behavior is undefined. The range may be empty (length 0),
					in which case the new values are merely inserted at the
					range location.
		newValues = A C array of the pointer-sized values to be placed
					into the array. The new values in the array are ordered in
					the same order in which they appear in this C array. This
					parameter may be NULL if the newCount parameter is 0. This
					C array is not changed or freed by this function. If this
					parameter is not a valid pointer to a C array of at least
					newCount pointers, the behavior is undefined.
		newCount =  The number of values to copy from the values C
					array into the CFArray. If this parameter is different than
					the range length, the excess newCount values will be
					inserted after the range, or the excess range values will be
					deleted. This parameter may be 0, in which case no new
					values are replaced into the array and the values in the
					range are simply removed. If this parameter is negative, or
					greater than the number of values actually in the newValues
					C array, the behavior is undefined.
*/
extern void CFArrayReplaceValues(CFMutableArrayRef theArray, CFRange range, const(void)** newValues, CFIndex newCount);

/**
	Exchanges the values at two indices of the array.

	Params:
		theArray =  The array of which the values are to be swapped. If
					this parameter is not a valid mutable CFArray, the behavior
					is undefined.
		idx1 =  	The first index whose values should be swapped. If the
					index is outside the index space of the array (0 to N-1
					inclusive, where N is the count of the array before the
					operation), the behavior is undefined.
		idx2 =  	The second index whose values should be swapped. If the
					index is outside the index space of the array (0 to N-1
					inclusive, where N is the count of the array before the
					operation), the behavior is undefined.
*/
extern void CFArrayExchangeValuesAtIndices(CFMutableArrayRef theArray, CFIndex idx1, CFIndex idx2);

/**
	Sorts the values in the array using the given comparison function.

	Params:
		theArray =  	The array whose values are to be sorted. If this
						parameter is not a valid mutable CFArray, the behavior is
						undefined.
		range =  		The range of values within the array to sort. If the
						range location or end point (defined by the location plus
						length minus 1) is outside the index space of the array (0
						to N-1 inclusive, where N is the count of the array), the
						behavior is undefined. If the range length is negative, the
						behavior is undefined. The range may be empty (length 0).
		comparator =  	The function with the comparator function type
						signature which is used in the sort operation to compare
						values in the array with the given value. If this parameter
						is not a pointer to a function of the correct prototype, the
						the behavior is undefined. If there are values in the array
						which the comparator function does not expect or cannot
						properly compare, the behavior is undefined. The values in
						the range are sorted from least to greatest according to
						this function.
		context =  		A pointer-sized user-defined value, which is passed
						as the third parameter to the comparator function, but is
						otherwise unused by this function. If the context is not
						what is expected by the comparator function, the behavior is
						undefined.
*/
extern void CFArraySortValues(CFMutableArrayRef theArray, CFRange range, CFComparatorFunction comparator, void* context);

/**
	Adds the values from an array to another array.

	Params:
		theArray =  	The array to which values from the otherArray are to
						be added. If this parameter is not a valid mutable CFArray,
						the behavior is undefined.
		otherArray =  	The array providing the values to be added to the
						array. If this parameter is not a valid CFArray, the
						behavior is undefined.
		otherRange =  	The range within the otherArray from which to add
						the values to the array. If the range location or end point
						(defined by the location plus length minus 1) is outside
						the index space of the otherArray (0 to N-1 inclusive, where
						N is the count of the otherArray), the behavior is
						undefined. The new values are retained by the array using
						the retain callback provided when the array was created. If
						the values are not of the sort expected by the retain
						callback, the behavior is undefined. The values are assigned
						to the indices one larger than the previous largest index
						in the array, and beyond, and the count of the array is
						increased by range.length. The values are assigned new
						indices in the array from smallest to largest index in the
						order in which they appear in the otherArray.
*/
extern void CFArrayAppendArray(CFMutableArrayRef theArray, CFArrayRef otherArray, CFRange otherRange);
