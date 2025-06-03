cmake_minimum_required(VERSION 3.31)
project(hyper-shared-ptr VERSION 0.1)
include(CTest)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fdiagnostics-color=always")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fdiagnostics-color=always")

find_package(fmt CONFIG REQUIRED)
find_package(glog CONFIG REQUIRED)

find_package(PkgConfig REQUIRED)
pkg_check_modules(librseq REQUIRED IMPORTED_TARGET GLOBAL librseq)

add_library(hyper-shared-ptr SHARED src/hyper-shared-ptr.cc)
add_library(theta::hyper-shared-ptr ALIAS hyper-shared-ptr)
target_include_directories(
  hyper-shared-ptr
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>)
target_link_libraries(hyper-shared-ptr PUBLIC fmt::fmt glog::glog
                                              PkgConfig::librseq)

install(
  TARGETS hyper-shared-ptr
  EXPORT ${PROJECT_NAME}
  DESTINATION $ENV{out})

install(
  EXPORT ${PROJECT_NAME}
  DESTINATION $ENV{out}/lib/cmake
  FILE ${PROJECT_NAME}-config.cmake
  NAMESPACE theta::)

if(BUILD_TESTING)
  add_subdirectory(test)
endif(BUILD_TESTING)

if($ENV{BUILD_BENCHMARKING})
  add_subdirectory(benchmark)
endif($ENV{BUILD_BENCHMARKING})
