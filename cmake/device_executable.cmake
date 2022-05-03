################################################################################
# Functions
################################################################################

#! AddDeviceExecutable Wrapper for add_executable() to create proper, flashable device executable. 
# 
# This function uses the same API as add_executable(), so the first argument is the executable name and the
# rest are the source files forwareded to add_executable().
function(AddDeviceExecutable target_name)

    add_executable(${target_name} ${ARGN})
    MakeDeviceExecutable(${target_name})

endfunction()

function(MakeDeviceExecutable target_name)

    target_link_libraries(${target_name} PRIVATE device)
    target_sources(${target_name} PRIVATE $<TARGET_OBJECTS:device_sources>)

endfunction()

function(CreateDeviceLibrary)

    set(demo_dir ${PROJECT_ROOT_DIR_FOR_DEVICE_EXECUTABLE_CMAKE}/demo)
    set(linker_script ${demo_dir}/STM32L432KCUx_FLASH.ld)

    add_library(device_sources OBJECT ${demo_dir}/startup_stm32l432xx.s)
    add_library(device STATIC 
        ${demo_dir}/system_stm32l4xx.c)

    target_compile_definitions(device PRIVATE STM32L432xx)
    target_include_directories(device PRIVATE demo/include)
    target_link_options(device PUBLIC -T${linker_script})

endfunction()

################################################################################
# Main script
################################################################################

set(PROJECT_ROOT_DIR_FOR_DEVICE_EXECUTABLE_CMAKE ${CMAKE_CURRENT_LIST_DIR}/..)

CreateDeviceLibrary()
