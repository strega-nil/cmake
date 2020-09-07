include(${CMAKE_ROOT}/Modules/CMakeDetermineCompiler.cmake)

# Local system-specific compiler preferences for this language.
include(Platform/${CMAKE_SYSTEM_NAME}-Determine-OCaml OPTIONAL)
include(Platform/${CMAKE_SYSTEM_NAME}-OCaml OPTIONAL)
if(NOT CMAKE_OCaml_COMPILER_NAMES)
  set(CMAKE_OCaml_COMPILER_NAMES ocamlopt)
endif()

if("${CMAKE_GENERATOR}" MATCHES "^Ninja")
  if(CMAKE_OCaml_COMPILER)
    _cmake_find_compiler_path(OCaml)
  else()
    set(CMAKE_OCaml_COMPILER_INIT NOTFOUND)

    if(NOT $ENV{OCAMLOPT} STREQUAL "")
      get_filename_component(CMAKE_OCaml_COMPILER_INIT $ENV{OCAMLOPT} PROGRAM
        PROGRAM_ARGS CMAKE_OCaml_FLAGS_ENV_INIT)
      if(CMAKE_OCaml_FLAGS_ENV_INIT)
        set(CMAKE_OCaml_COMPILER_ARG1 "${CMAKE_OCaml_FLAGS_ENV_INIT}" CACHE
          STRING "Arguments to ocamlopt")
      endif()
      if(NOT EXISTS ${CMAKE_OCaml_COMPILER_INIT})
        message(FATAL_ERROR
"Could not find compiler set in environment variable OCAMLOPT
$ENV{OCAMLOPT}
${CMAKE_OCaml_COMPILER_INIT}")
      endif()
    endif()

    if(NOT CMAKE_OCaml_COMPILER_INIT)
      set(CMAKE_OCaml_COMPILER_LIST ocamlopt ${_CMAKE_TOOLCHAIN_PREFIX}ocamlopt)
    endif()

    _cmake_find_compiler(OCaml)
  endif()
  mark_as_advanced(CMAKE_OCaml_COMPILER)
else()
  message(FATAL_ERROR "OCaml language not supported by \"${CMAKE_GENERATOR}\" generator")
endif()

if(NOT CMAKE_OCaml_COMPILER_ID_RUN)
  set(CMAKE_OCaml_COMPILER_ID_RUN 1)

  set(CMAKE_OCaml_COMPILER_ID)
  include(${CMAKE_ROOT}/Modules/CMakeDetermineCompilerId.cmake)
  CMAKE_DETERMINE_COMPILER_ID(OCaml "" CompilerId/main.ml)
endif()

if(NOT _CMAKE_TOOLCHAIN_LOCATION)
  get_filename_component(_CMAKE_TOOLCHAIN_LOCATION "${CMAKE_OCaml_COMPILER}" PATH)
endif()

# TODO: figure this out
set(_CMAKE_PROCESSING_LANGUAGE "OCaml")
include(CMakeFindBinUtils)
unset(_CMAKE_PROCESSING_LANGUAGE)

configure_file(${CMAKE_ROOT}/Modules/CMakeOCamlCompiler.cmake.in
               ${CMAKE_PLATFORM_INFO_DIR}/CMakeOCamlCompiler.cmake @ONLY)

set(CMAKE_OCaml_COMPILER_ENV_VAR "OCAMLOPT")
