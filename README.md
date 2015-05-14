PortAudio binaries
==================

This repository provides pre-compiled dynamic libraries for
[PortAudio](http://www.portaudio.com/).

DLLs for Windows (32-bit and 64-bit)
------------------------------------

The DLLs include all available host APIs, namely WMME, DirectSound, WDM/KS,
WASAPI and ASIO.  For more informaton about the ASIO SDK see
http://www.steinberg.net/en/company/developers.html.

    JOBS=8
    git clone https://github.com/mxe/mxe.git
    curl -O http://www.steinberg.net/sdk_downloads/asiosdk2.3.zip
    export PATH=$(pwd)"/mxe/usr/bin:$PATH"

Open the file `mxe/src/portaudio.mk` and change
`--with-winapi=wmme,directx,wdmks,wasapi` to
`--with-winapi=wmme,directx,wdmks,wasapi,asio` (and make sure to keep the
backslash at the end of the line).
To the first line starting with "$(MAKE)", append " EXAMPLES= SELFTESTS=" (without the quotes).
Delete the 4 lines before the last line (i.e. keep the line with "endef").
After saving your changes, please continue:

    for TARGET in x86_64-w64-mingw32.static i686-w64-mingw32.static
    do
        unzip asiosdk2.3.zip
        # You'll need write access in /usr/local for this:
        mv ASIOSDK2.3 /usr/local/asiosdk2
        # If it doesn't work, prepend "sudo " to the previous command
        make -C mxe portaudio -j$JOBS JOBS=$JOBS MXE_TARGETS=$TARGET
        $TARGET-gcc -O2 -shared -o libportaudio-$TARGET.dll -Wl,--whole-archive -lportaudio -Wl,--no-whole-archive -lstdc++ -lwinmm -lole32 -lsetupapi
        $TARGET-strip libportaudio-$TARGET.dll
        chmod -x libportaudio-$TARGET.dll
        # again, you'll probably have to use "sudo":
        rm -r /usr/local/asiosdk2
    done

    mv libportaudio-x86_64-w64-mingw32.static.dll libportaudio64bit.dll
    mv libportaudio-i686-w64-mingw32.static.dll libportaudio32bit.dll

A different set of DLLs (compiled with Visual Studio) is available at
https://github.com/adfernandes/precompiled-portaudio-windows.

dylib for Mac OS X (64-bit)
---------------------------

    JOBS=8
    curl -O http://www.portaudio.com/archives/pa_stable_v19_20140130.tgz
    tar xvf pa_stable_v19_20140130.tgz
    cd portaudio
    # in configure: replace "-Werror" (just search for it) with "-DNDEBUG"
    ./configure --disable-mac-universal
    make -j$JOBS
    cd ..
    cp portaudio/lib/.libs/libportaudio.2.dylib libportaudio.dylib

Copyright
---------

* PortAudio by Ross Bencina and Phil Burk, MIT License.

* Steinberg Audio Stream I/O API by Steinberg Media Technologies GmbH.
