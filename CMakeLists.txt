cmake_minimum_required(VERSION 3.21)

set(CMAKE_BUILD_TYPE "Release" CACHE STRING "CMake build configuration")

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
include(dependencies)

ProvideLlvm()
ProvideArmGnuToolchain()
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_LIST_DIR}/cmake/clang_with_arm_gnu_libs_device_toolchain.cmake CACHE PATH
    "Path to the CMake's toolchain file")

project(ProjectName LANGUAGES CXX C ASM)

set(DEVICE_LINKER_SCRIPT "" CACHE PATH "Path to the linker script")

include(device_executable)

