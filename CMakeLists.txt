#**********************************************************************************#
# Copyright by @bkozdras <b.kozdras@gmail.com>                                     #
# Purpose: To prepare AVR environment and optional run unit tests.                 #
# Version: 1.0                                                                     #
# Licence: MIT                                                                     #
#**********************************************************************************#

message(STATUS "Processing: ${CMAKE_CURRENT_LIST_FILE}")

cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

set(ROOT_DIR ${CMAKE_CURRENT_SOURCE_DIR})

execute_process(COMMAND uname -m
    COMMAND tr -d '\n'
    OUTPUT_VARIABLE THIS_ARCH)

include(cmake/ParseOptions.cmake)
if (BUILD_FOR_TARGET)
    include(cmake/SetTargetOptions.cmake)
    include(cmake/GenericAvrCMake.cmake)
    include(cmake/CopyAvrLibcIncludes.cmake)
endif (BUILD_FOR_TARGET)

set(PROJECT_NAME AvrDevelopmentFramework)

project(${PROJECT_NAME} VERSION 1.0)

message(STATUS "Project name: ${PROJECT_NAME}")
message(STATUS "Target architecture: AVR")
message(STATUS "This architecture \(used for tests only\): ${THIS_ARCH}")

enable_language(C)

if (GENERATE_CODE_COVERAGE)
    include(cmake/CodeCoverage.cmake)
    append_coverage_compiler_flags()
    add_compile_options(-O0)
endif (GENERATE_CODE_COVERAGE)

if (USE_ADDRESS_SANITIZER)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-omit-frame-pointer -fsanitize=address -fsanitize=leak -g")
    set(CMAKE_LINKER_FLAGS "${CMAKE_LINKER_FLAGS} -fno-omit-frame-pointer -fsanitize=address -fsanitize=leak")
    set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -fno-omit-frame-pointer -fsanitize=address -fsanitize=leak")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fno-omit-frame-pointer -fsanitize=address -fsanitize=leak")
endif (USE_ADDRESS_SANITIZER)

set(INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
set(HEADERS_DIR ${INCLUDE_DIR}/avrframework)
include_directories(${INCLUDE_DIR})

set(MOCK_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mock)
set(MOCK_HEADERS_DIR ${MOCK_INCLUDE_DIR}/avrframeworkmock)
include_directories(${MOCK_INCLUDE_DIR})

set(STUB_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/stub)
set(STUB_HEADERS_DIR ${STUB_INCLUDE_DIR}/avrframeworkstub)
include_directories(${STUB_INCLUDE_DIR})

if (BUILD_LIBRARY OR BUILD_FOR_TARGET)
    add_subdirectory(src)
endif (BUILD_LIBRARY OR BUILD_FOR_TARGET)

if (BUILD_STUB_LIBRARY)
    add_subdirectory(stub)
endif (BUILD_STUB_LIBRARY)

if (BUILD_UNIT_TESTS)
    enable_testing()
    include(cmake/FetchCMocka.cmake)
    add_subdirectory(test)
endif (BUILD_UNIT_TESTS)

if (BUILD_TEST_EXECUTABLE_FOR_TARGET)
    add_subdirectory(test-programs)
endif (BUILD_TEST_EXECUTABLE_FOR_TARGET)
