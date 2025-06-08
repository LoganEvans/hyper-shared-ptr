cmake_minimum_required(VERSION 3.31)
project(hyper-shared-ptr VERSION 0.1)
include(CTest)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_compile_options(-fdiagnostics-color=always
                    -Wno-unused-command-line-argument)
add_link_options(-Wno-unused-command-line-argument)

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

if(BUILD_TESTING)
  add_subdirectory(test)
endif(BUILD_TESTING)

if($ENV{BUILD_BENCHMARK})
  add_subdirectory(benchmark)
endif($ENV{BUILD_BENCHMARK})

install(
  TARGETS hyper-shared-ptr
  EXPORT ${PROJECT_NAME}
  DESTINATION $ENV{out}/lib)

install(
  EXPORT ${PROJECT_NAME}
  DESTINATION $ENV{out}/lib/cmake
  FILE ${PROJECT_NAME}-config.cmake
  NAMESPACE theta::)
