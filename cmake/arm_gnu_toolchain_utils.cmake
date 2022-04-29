# ArmGnu_* prefix have public functions.
# ArmGnu__* prefix have private functions.

#! ArmGnu_GetStandardLibrariesDirectory   Returns path to libc, libm, libstdc++, and friends, for the specified architecture.
# \arg:basic_architecture_flags    Basic architecture flags string, which contains -mcpu, -mfloat-abi, -mfpu, -mthumb, ...
# \arg:result_out_var              Will be set to the resulting path.
function(ArmGnu_GetStandardLibrariesDirectory basic_architecture_flags result_out_var)

    separate_arguments(get_libc_location_command NATIVE_COMMAND 
        "${ARM_GNU_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc ${basic_architecture_flags} -print-file-name=libc.a")
    execute_process(COMMAND ${get_libc_location_command} OUTPUT_VARIABLE path_to_libc)
   
    get_filename_component(standard_libraries_dir ${path_to_libc} DIRECTORY)
    cmake_path(NORMAL_PATH standard_libraries_dir)

    set(${result_out_var} ${standard_libraries_dir} PARENT_SCOPE)

endfunction()

#! ArmGnu_GetCompilerRuntimeLibrariesDirectory   Returns path to libgcc, crt* and friends, for the specified architecture.
# \arg:basic_architecture_flags           Basic architecture flags string, which contains 
#                                         -mcpu, -mfloat-abi, -mfpu, -mthumb, ...
# \arg:result_out_var                     Will be set to the resulting path.
function(ArmGnu_GetCompilerRuntimeLibrariesDirectory basic_architecture_flags result_out_var)

    separate_arguments(get_libgcc_location_command NATIVE_COMMAND 
        "${ARM_GNU_TOOLCHAIN_PATH}/bin/arm-none-eabi-gcc ${basic_architecture_flags} -print-libgcc-file-name")
    execute_process(COMMAND ${get_libgcc_location_command} OUTPUT_VARIABLE path_to_libgcc)
   
    get_filename_component(runtime_libs_dir ${path_to_libgcc} DIRECTORY)
    cmake_path(NORMAL_PATH runtime_libs_dir)

    set(${result_out_var} ${runtime_libs_dir} PARENT_SCOPE)

endfunction()

#! ArmGnu_GetCSystemIncludeFlags  Returns '-isystem' flags for C language as a string.
# \arg:basic_architecture_flags   Basic architecture flags string, which contains -mcpu, -mfloat-abi, -mfpu, -mthumb, ...
# \arg:result_out_var             Will be set to the resulting flags: '-isystem some/path/1 -isystem some/path/2 ...'
function(ArmGnu_GetCSystemIncludeFlags basic_architecture_flags result_out_var)

    ArmGnu__CreateDummyEmptyFile(dummy_empty_file_path)

    set(cpp ${ARM_GNU_TOOLCHAIN_PATH}/bin/arm-none-eabi-cpp)
    separate_arguments(cmd NATIVE_COMMAND 
        "${cpp} ${basic_architecture_flags} -v -E -")
    execute_process(COMMAND ${cmd} 
        OUTPUT_VARIABLE cmd_out
        ERROR_VARIABLE cmd_out
        INPUT_FILE ${dummy_empty_file_path})

    ArmGnu__ParseIncludeDirs(${cmd_out} result)
    set(${result_out_var} ${result} PARENT_SCOPE)

endfunction()

#! ArmGnu_GetCxxSystemIncludeFlags  Returns '-isystem' flags for C++ language as a string.
# \arg:basic_architecture_flags     Basic architecture flags string, which contains -mcpu, -mfloat-abi, -mfpu, -mthumb, ...
# \arg:result_out_var               Will be set to the resulting flags: '-isystem some/path/1 -isystem some/path/2 ...'
function(ArmGnu_GetCxxSystemIncludeFlags basic_architecture_flags result_out_var)

    ArmGnu__CreateDummyEmptyFile(dummy_empty_file_path)

    set(cpp ${ARM_GNU_TOOLCHAIN_PATH}/bin/arm-none-eabi-cpp)
    separate_arguments(cmd NATIVE_COMMAND 
        "${cpp} ${basic_architecture_flags} -xc++ -v -E -")

    execute_process(COMMAND ${cmd} 
        OUTPUT_VARIABLE cmd_out
        ERROR_VARIABLE cmd_out
        INPUT_FILE ${dummy_empty_file_path})

    ArmGnu__ParseIncludeDirs(${cmd_out} result)
    set(${result_out_var} ${result} PARENT_SCOPE)

endfunction()

#! ArmGnu__CreateDummyEmptyFile Creates an empty file and sets result_out_var to the path where it created.
function(ArmGnu__CreateDummyEmptyFile result_out_var)
    
    set(path ${CMAKE_CURRENT_BINARY_DIR}/dummy_empty_file.txt)
    execute_process(COMMAND ${CMAKE_COMMAND} -E touch ${path})
    set(${result_out_var} ${path} PARENT_SCOPE)

endfunction()

function(ArmGnu__ParseIncludeDirs cpp_verbose_command_output result_out_var)

    set(includes_begin_string "#include <...> search starts here:")
    string(FIND ${cpp_verbose_command_output} ${includes_begin_string} includes_begin_index)
    if(includes_begin_index LESS 0)
        message(FATAL_ERROR "Failed to retrieve include paths begin token")
    endif()

    string(LENGTH ${includes_begin_string} includes_begin_string_length)
    math(EXPR includes_begin_index "${includes_begin_index} + ${includes_begin_string_length}")

    string(SUBSTRING ${cmd_out} ${includes_begin_index} -1 includes)
    string(FIND ${includes} "End of search list." includes_end_index)

    if(includes_end_index LESS 0)
        message(FATAL_ERROR "Failed to retrieve include paths end token")
    endif()

    string(SUBSTRING ${includes} 0 ${includes_end_index} includes)
    string(STRIP ${includes} includes)
    string(REGEX REPLACE "[ \t\r\n]" ";" includes ${includes})
    # Quoutes are needed with "${includes}", because the previous command made 'includes' variable a list.
    string(REGEX REPLACE ";+" ";" includes "${includes}")
    list(JOIN includes " -isystem " includes)
    set(includes "-isystem ${includes}")

    set(${result_out_var} ${includes} PARENT_SCOPE)

endfunction()
