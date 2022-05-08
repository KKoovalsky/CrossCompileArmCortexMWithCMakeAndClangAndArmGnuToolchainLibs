# ARM Cortex M C++ firmware cross-compilation with Clang

This template allows creating projects which utilizes:

* ARM Cortex M microcontroller,
* CMake,
* LLVM+Clang,
* ARM GNU GCC Toolchain.

`clang` is used for cross-compilation. The pre-built standard libraries and compiler runtime is taken from the
ARM GNU Toolchain.

The `CMAKE_TOOLCHAIN_FILE` is set to `cmake/clang_with_arm_gnu_libs_device_toolchain.cmake` by default. There is no
need to specify it within the command line, thus calling:

```
mkdir build
cd build
cmake ..
```

Is sufficient.

You can create multiple executables with this setup. Simply call `AddDeviceExecutable()` within the CMake code, to
create a flashable executable. The function has the same interface as the `add_executable()` builtin.

## Customization

### 1. Custom path to the LLVM Toolchain and the ARM GNU GCC Toolchain

By default, the LLVM Toolchain and the ARM GNU GCC Toolchain will be downloaded using the `FetchContent` module.
Ubuntu 20 is targeted by default. To override the defaults, edit the `dependencies.cmake` file, where URL paths are
located. To provide a local path to a toolchain, use CMake CACHE variables:

* `-DFETCHCONTENT_SOURCE_DIR_LLVM=path/to/local/llvm+clang/toolchain`
* `-DFETCHCONTENT_SOURCE_DIR_ARMGNUTOOLCHAIN=path/to/local/armgnutoolchain`

Set it before the first run of the CMake configure step.

**NOTE:** The toolchains are downloaded under `<project_root>/.deps` directory to avoid re-downloading for multiple
build trees.

### 2. Creation of the device executable

The function `AddDeviceExecutable()`, within `device_executable.cmake`, links custom `device_sources` and `device` 
targets, created with `CreateDeviceLibrary()`, to create a proper "flashable" executable. This must be customized
according to your hardware.

Basically, the `AddDeviceExecutable()` must:

* Link a proper linker script to the executable target.
* Add the startup file OBJECT to the executable objects. It is preferred to link the startup file as an OBJECT library,
because it is naturally a part of the executable. It may be also a STATIC library, though.
* Link all the needed source files (can be a STATIC library) needed by the startup code, and all the include header
paths.

The [demo](demo/) directory contains such a basic setup, just to demonstrate. The example implementation of
the `AddDeviceExecutable()` uses those files to create a device executable for the STM32L432KC MCU.

### 3. Custom terminate handler

The terminate handler supplied with the `libsupc++` from ARM GNU Toolchain is quite heavy. It occupies around
60 kB in the Release mode. You can use `CreateCustomTerminateLib()` and `LinkCustomTerminate()`, from 
`device_executable.cmake`, to override the heavy default. The implementation of the custom terminate handler
used, is taken from the [src/device/custom_terminate.cpp](src/device/custom_terminate.cpp). You can fill
the body of the `terminate()` function however you like.

### 4. Printing binary size after build

Use `PrintBinarySizeAfterBuild()` within the `AddDeviceExecutable()`. It will print the binary size after building
the executable target.

### 5. Adding 'flash' targets

It is quite convenient being able to flash an executable target from the build tree. To do that, you can create
a CMake function, within the `device_executable.cmake`:

```
function(AddFlashTarget target_name)

    add_custom_target(${target_name}-flash
        COMMAND <your flasher program here> $<TARGET_FILE:${target_name}>
        # VERBATIM (or not VERBATIM)
    )

endfunction()
```

This will create a `<target_name>-flash` target invocable within the build tree:

```
cmake --build . --target <your_executable>-flash
```

Make sure to call the `AddFlashTarget()` within the `AddDeviceExecutable()` function.

### 6. Remove the unneeded code

The calls to `AddDeviceExecutable()` within the main `CMakeLists.txt` are demonstratory, as well as the `demo/` 
directory.
