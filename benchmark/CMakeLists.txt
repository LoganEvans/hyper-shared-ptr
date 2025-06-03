find_package(benchmark REQUIRED)

add_executable(hyper-shared-ptr-benchmark hyper-shared-ptr-benchmark.cc)
target_link_libraries(hyper-shared-ptr-benchmark
                      PRIVATE benchmark::benchmark theta::hyper-shared-ptr)

install(
  TARGETS hyper-shared-ptr-benchmark
  EXPORT ${PROJECT_NAME}
  DESTINATION $ENV{out}/benchmark)
