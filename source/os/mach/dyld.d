/*
    Copyright © 2024, Kitsunebi Games EMV
    Distributed under the Boost Software License, Version 1.0, 
    see LICENSE file.
    
    Authors: Luna Nielsen
*/

/**
    Extensions to dyld API.
*/
module os.mach.dyld;
import dyld = core.sys.darwin.mach.dyld;
import core.sys.darwin.dlfcn;
import core.sys.darwin.mach.loader;
import core.sys.darwin.mach.dyld : 
    _dyld_get_image_header,
    _dyld_get_image_name,
    _dyld_image_count;

version (OSX)
    version = Darwin;
else version (iOS)
    version = Darwin;
else version (TVOS)
    version = Darwin;
else version (WatchOS)
    version = Darwin;

version (Darwin):
extern (C) nothrow @nogc:

/**
    32-bit mach header.
*/
alias mach_header_32 = dyld.mach_header;

/**
    64-bit mach header.
*/
alias mach_header_64 = dyld.mach_header_64;

/**
    32-bit mach section.
*/
alias mach_section_32 = dyld.section;

/**
    64-bit mach section.
*/
alias mach_section_64 = dyld.section_64;

/**
    32-bit mach section.
*/
alias mach_segment_32 = dyld.segment_command;

/**
    64-bit mach section.
*/
alias mach_segment_64 = dyld.segment_command_64;

/**
    A mach header which matches the current device's architecture.
*/
version(D_LP64) alias mach_header = mach_header_64;
else alias mach_header = mach_header_32;

/**
    A mach section which matches the current device's architecture.
*/
version(D_LP64) alias mach_section = mach_section_64;
else alias mach_section = mach_section_32;

/**
    A mach segment which matches the current device's architecture.
*/
version(D_LP64) alias mach_segment = mach_segment_64;
else alias mach_segment = mach_segment_32;

// Mask value for the mode value added to a dlopen handle.
enum size_t RTLD_MODEMASK = cast(size_t)-4;

/**
    Attempt to find a mach_header from its dlopen handle.

    Returns: mach_header address or `null` on failure.
*/
const(mach_header)* dyld_get_dlopen_image_header(void* handle) {
    auto idx = dylib_get_dlopen_image_index(handle);
    if (idx >= 0) {
        return cast(const(mach_header)*)_dyld_get_image_header(cast(uint)idx);
    }
    return null;
}

/**
    Attempts to get the image path of a dlopen handle.

    Returns: Image path on success, `null` on failure.
*/
const(char)* dylib_get_dlopen_image_path(void* handle) {
    auto idx = dylib_get_dlopen_image_index(handle);
    if (idx >= 0) {
        return _dyld_get_image_name(cast(uint)idx);
    }
    return null;
}

/**
    Attempts to get the image index of a dlopen handle.

    Returns: Image index on success, `-1` on failure.
*/
ptrdiff_t dylib_get_dlopen_image_index(void* handle) {
    foreach(i; 0.._dyld_image_count()) {

        // By passing RTLD_NOLOAD we won't be attempting to
        // load an unloaded library.
        // This prevents oopsies where you're trying to get the index
        // of an image that is somehow not loaded (name mismatch??)
        const(char)* name = _dyld_get_image_name(i);
        if (void* probeHandle = dlopen(name, RTLD_NOLOAD | RTLD_LAZY)) {
            dlclose(probeHandle);

            // We strip the mode bits off the handle.
            // So that we can match handles despite which RTLD parameters were passed.
            if ((cast(size_t)handle & RTLD_MODEMASK) == 
                (cast(size_t)probeHandle & RTLD_MODEMASK))
                    return i;
        }
    }
    return -1;
}

/**
    Finds dlopen handle associated with the given mach_header.

    Returns: Handle on success, `-1` on failure.
*/
void* dylib_get_handle_for_header(const(mach_header)* header) {
    Dl_info info;
    if (dladdr(header, &info)) {

        // Lookup the handle by getting the dli_fname from the header.
        // since the header is located *within* the address space of
        // the dylib.
        void* handle = dlopen(info.dli_fname, RTLD_NOLOAD | RTLD_LAZY);
        dlclose(handle);
        return handle;
    }

    // Not found.
    return null;
}