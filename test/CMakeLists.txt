find_package(GTest REQUIRED)
find_package(debug-utils CONFIG REQUIRED)
include(GoogleTest)

add_executable(hyper-shared-ptr-test hyper-shared-ptr-test.cc)
target_link_libraries(
  hyper-shared-ptr-test
  PRIVATE GTest::gmock GTest::gtest_main theta::debug
          theta::stacktrace-signal-handlers theta::hyper-shared-ptr)
gtest_discover_tests(hyper-shared-ptr-test)
