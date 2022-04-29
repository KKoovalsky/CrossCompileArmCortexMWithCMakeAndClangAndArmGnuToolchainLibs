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

