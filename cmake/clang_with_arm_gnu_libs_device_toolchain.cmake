set(CLANG_COMPILER_PATH_PREFIX ${LLVM_TOOLCHAIN_PATH}/bin)

# Without that you will get linking error related to no _exit symbol when CMake tests the compiler.
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER ${CLANG_COMPILER_PATH_PREFIX}/clang)
set(CMAKE_CXX_COMPILER ${CLANG_COMPILER_PATH_PREFIX}/clang++)

set(CMAKE_ASM_COMPILER ${CLANG_COMPILER_PATH_PREFIX}/clang)
set(CMAKE_LINKER ${CLANG_COMPILER_PATH_PREFIX}/lld)

set(CMAKE_AR ${CLANG_COMPILER_PATH_PREFIX}/llvm-ar)
set(CMAKE_OBJCOPY ${CLANG_COMPILER_PATH_PREFIX}/llvm-objcopy)
set(CMAKE_RANLIB ${CLANG_COMPILER_PATH_PREFIX}/llvm-ranlib)
set(CMAKE_STRIP ${CLANG_COMPILER_PATH_PREFIX}/llvm-strip)
set(CMAKE_SIZE ${CLANG_COMPILER_PATH_PREFIX}/llvm-size)

set(basic_architecture_flags 
    "-mthumb -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16")

set(basic_flags "${basic_architecture_flags} -fdata-sections -ffunction-sections")

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES ARM_GNU_TOOLCHAIN_PATH)

include(${CMAKE_CURRENT_LIST_DIR}/arm_gnu_toolchain_utils.cmake)
ArmGnu_GetCSystemIncludeFlags(${basic_architecture_flags} c_system_includes)
ArmGnu_GetCxxSystemIncludeFlags(${basic_architecture_flags} cxx_system_includes)
ArmGnu_GetStandardLibrariesDirectory(${basic_architecture_flags} standard_libraries_dir)
ArmGnu_GetCompilerRuntimeLibrariesDirectory(${basic_architecture_flags} compiler_runtime_libraries_dir)

include(${CMAKE_CURRENT_LIST_DIR}/llvm_toolchain_utils.cmake)
Llvm_GetDummyLibunwindDirectory(libunwind_dir)

string(CONCAT exe_linker_flags
    " --rtlib=libgcc"
    " --stdlib=libstdc++"
    " -L${standard_libraries_dir}"
    " -L${compiler_runtime_libraries_dir}"
    " -L${libunwind_dir}"
    " ${compiler_runtime_libraries_dir}/crti.o"
    " ${compiler_runtime_libraries_dir}/crtbegin.o"
    " ${compiler_runtime_libraries_dir}/crtend.o"
    " ${compiler_runtime_libraries_dir}/crtn.o"
    " -lnosys"
    " -Wl,--gc-sections"
    " -Wl,--target2=rel"
)

set(CMAKE_C_FLAGS_INIT "${basic_flags} ${c_system_includes}")
set(CMAKE_ASM_FLAGS_INIT  "${basic_architecture_flags}")
set(CMAKE_CXX_FLAGS_INIT "${basic_flags} ${cxx_system_includes}")

set(CMAKE_EXE_LINKER_FLAGS_INIT "${exe_linker_flags}")

set(CMAKE_C_COMPILER_TARGET arm-none-eabi)
set(CMAKE_CXX_COMPILER_TARGET arm-none-eabi)
set(CMAKE_ASM_COMPILER_TARGET arm-none-eabi)

