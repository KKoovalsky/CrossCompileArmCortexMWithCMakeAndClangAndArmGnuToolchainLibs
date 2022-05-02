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

    target_link_options(${target_name} PRIVATE -T${DEVICE_LINKER_SCRIPT})

endfunction()

################################################################################
# Main script
################################################################################

if(NOT DEVICE_LINKER_SCRIPT)
    message(FATAL_ERROR " DEVICE_LINKER_SCRIPT must be set to a path to a proper linker script.")
endif()
