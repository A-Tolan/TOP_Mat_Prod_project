# Generated by CMake

if("${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}" LESS 2.8)
   message(FATAL_ERROR "CMake >= 2.8.0 required")
endif()
if(CMAKE_VERSION VERSION_LESS "2.8.3")
   message(FATAL_ERROR "CMake >= 2.8.3 required")
endif()
cmake_policy(PUSH)
cmake_policy(VERSION 2.8.3...3.26)
#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

if(CMAKE_VERSION VERSION_LESS 3.0.0)
  message(FATAL_ERROR "This file relies on consumers using CMake 3.0.0 or greater.")
endif()

# Protect against multiple inclusion, which would fail when already imported targets are added once more.
set(_cmake_targets_defined "")
set(_cmake_targets_not_defined "")
set(_cmake_expected_targets "")
foreach(_cmake_expected_target IN ITEMS Kokkos::LIBDL Kokkos::kokkoscore Kokkos::kokkoscontainers Kokkos::kokkosalgorithms Kokkos::kokkossimd Kokkos::kokkos)
  list(APPEND _cmake_expected_targets "${_cmake_expected_target}")
  if(TARGET "${_cmake_expected_target}")
    list(APPEND _cmake_targets_defined "${_cmake_expected_target}")
  else()
    list(APPEND _cmake_targets_not_defined "${_cmake_expected_target}")
  endif()
endforeach()
unset(_cmake_expected_target)
if(_cmake_targets_defined STREQUAL _cmake_expected_targets)
  unset(_cmake_targets_defined)
  unset(_cmake_targets_not_defined)
  unset(_cmake_expected_targets)
  unset(CMAKE_IMPORT_FILE_VERSION)
  cmake_policy(POP)
  return()
endif()
if(NOT _cmake_targets_defined STREQUAL "")
  string(REPLACE ";" ", " _cmake_targets_defined_text "${_cmake_targets_defined}")
  string(REPLACE ";" ", " _cmake_targets_not_defined_text "${_cmake_targets_not_defined}")
  message(FATAL_ERROR "Some (but not all) targets in this export set were already defined.\nTargets Defined: ${_cmake_targets_defined_text}\nTargets not yet defined: ${_cmake_targets_not_defined_text}\n")
endif()
unset(_cmake_targets_defined)
unset(_cmake_targets_not_defined)
unset(_cmake_expected_targets)


# Create imported target Kokkos::LIBDL
add_library(Kokkos::LIBDL INTERFACE IMPORTED)

set_target_properties(Kokkos::LIBDL PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "/usr/include"
  INTERFACE_LINK_LIBRARIES "dl"
)

# Create imported target Kokkos::kokkoscore
add_library(Kokkos::kokkoscore STATIC IMPORTED)

set_target_properties(Kokkos::kokkoscore PROPERTIES
  INTERFACE_COMPILE_DEFINITIONS "\$<\$<COMPILE_LANGUAGE:CXX>:KOKKOS_DEPENDENCE>"
  INTERFACE_COMPILE_FEATURES "cxx_std_17"
  INTERFACE_COMPILE_OPTIONS "\$<\$<COMPILE_LANGUAGE:CXX>:>"
  INTERFACE_INCLUDE_DIRECTORIES "/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build/core/src;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-src/core/src;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-src/tpls/desul/include;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-src/tpls/mdspan/include"
  INTERFACE_LINK_LIBRARIES "Kokkos::LIBDL"
  INTERFACE_LINK_OPTIONS "\$<\$<LINK_LANGUAGE:CXX>:-DKOKKOS_DEPENDENCE>"
)

# Create imported target Kokkos::kokkoscontainers
add_library(Kokkos::kokkoscontainers STATIC IMPORTED)

set_target_properties(Kokkos::kokkoscontainers PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build/containers/src;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-src/containers/src"
  INTERFACE_LINK_LIBRARIES "Kokkos::kokkoscore"
)

# Create imported target Kokkos::kokkosalgorithms
add_library(Kokkos::kokkosalgorithms INTERFACE IMPORTED)

set_target_properties(Kokkos::kokkosalgorithms PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build/algorithms/src;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-src/algorithms/src"
)

# Create imported target Kokkos::kokkossimd
add_library(Kokkos::kokkossimd STATIC IMPORTED)

set_target_properties(Kokkos::kokkossimd PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build/simd/src;/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-src/simd/src"
)

# Create imported target Kokkos::kokkos
add_library(Kokkos::kokkos INTERFACE IMPORTED)

set_target_properties(Kokkos::kokkos PROPERTIES
  INTERFACE_LINK_LIBRARIES "Kokkos::kokkoscore;Kokkos::kokkoscontainers;Kokkos::kokkosalgorithms;Kokkos::kokkossimd"
)

# Import target "Kokkos::kokkoscore" for configuration ""
set_property(TARGET Kokkos::kokkoscore APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(Kokkos::kokkoscore PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build/core/src/libkokkoscore.a"
  )

# Import target "Kokkos::kokkoscontainers" for configuration ""
set_property(TARGET Kokkos::kokkoscontainers APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(Kokkos::kokkoscontainers PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build/containers/src/libkokkoscontainers.a"
  )

# Import target "Kokkos::kokkossimd" for configuration ""
set_property(TARGET Kokkos::kokkossimd APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(Kokkos::kokkossimd PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "/home/andreea/Documents/Projects_VScode/chps/TOP/Top_Eval/TOP_Mat_Prod_project/lab3/matrix-product/build/_deps/kokkos-build/simd/src/libkokkossimd.a"
  )

# This file does not depend on other imported targets which have
# been exported from the same project but in a separate export set.

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
cmake_policy(POP)
