#! Llvm_GetDummyLibunwindDirectory Creates an empty libunwind.a and returns directory where it is located.
function(Llvm_GetDummyLibunwindDirectory result_out_var)

    set(libunwind_dir ${CMAKE_CURRENT_BINARY_DIR}/dummy_libunwind)
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${libunwind_dir})
    execute_process(COMMAND ${CMAKE_COMMAND} -E touch ${libunwind_dir}/libunwind.a)
    set(${result_out_var} ${libunwind_dir} PARENT_SCOPE)

endfunction()
