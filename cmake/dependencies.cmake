function(ProvideLlvm)
    include(FetchContent)
    FetchContent_Declare(
        Llvm
        URL https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/clang+llvm-14.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
        URL_HASH SHA256=61582215dafafb7b576ea30cc136be92c877ba1f1c31ddbbd372d6d65622fef5
    )
    FetchContent_MakeAvailable(Llvm)
    FetchContent_GetProperties(Llvm SOURCE_DIR LLVM_TOOLCHAIN_SOURCE_DIR)
    set(LLVM_TOOLCHAIN_PATH "${LLVM_TOOLCHAIN_SOURCE_DIR}" CACHE PATH "Path to the LLVM toolchain") 
endfunction()

function(ProvideArmGnuToolchain)
    include(FetchContent)
    FetchContent_Declare(
        ArmGnuToolchain
        URL https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2
        URL_HASH MD5=2383e4eb4ea23f248d33adc70dc3227e
    )
    FetchContent_MakeAvailable(ArmGnuToolchain)
    FetchContent_GetProperties(ArmGnuToolchain SOURCE_DIR ARM_GNU_TOOLCHAIN_SOURCE_DIR)
    set(ARM_GNU_TOOLCHAIN_PATH "${ARM_GNU_TOOLCHAIN_SOURCE_DIR}" CACHE PATH "Path to the ARM GNU toolchain")
endfunction()

