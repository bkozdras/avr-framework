#**********************************************************************************#
# Copyright by @bkozdras <b.kozdras@gmail.com>                                     #
# Purpose: To fetch CMocka external library.                                       #
# Version: 1.0                                                                     #
# Licence: MIT                                                                     #
#**********************************************************************************#

message(STATUS "Processing: ${CMAKE_CURRENT_LIST_FILE}")

include(FetchContent)

FetchContent_Declare(
    cmocka
    URL https://cmocka.org/files/1.1/cmocka-1.1.5.tar.xz
)

set(WITH_SHARED_LIB OFF CACHE BOOL "CMocka: Build with a shared library")
set(WITH_STATIC_LIB ON CACHE BOOL "CMocka: Build with a static library")
set(WITH_CMOCKERY_SUPPORT OFF CACHE BOOL "CMocka: Install a cmockery header")
set(WITH_EXAMPLES OFF CACHE BOOL "CMocka: Build examples")
set(UNIT_TESTING OFF CACHE BOOL "CMocka: Build with unit testing")
set(PICKY_DEVELOPER OFF CACHE BOOL "CMocka: Build with picky developer flags")

FetchContent_MakeAvailable(cmocka)
