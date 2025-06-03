{
  clangStdenv,
  cmake,
  fmt,
  gbenchmark,
  glog,
  gtest,
  librseq,
  pkgconf,
  src,
  theta-debug-utils,
  linuxPackages,
  flamegraph,
}:
let
in
clangStdenv.mkDerivation {
  inherit src;
  name = "hyper-shared-ptr";

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = [
    fmt
    gbenchmark
    glog
    gtest
    librseq
    theta-debug-utils
  ];

  nativeBuildInputs = [
    cmake
    pkgconf
    linuxPackages.perf
    flamegraph
  ];

  dontStrip = true;
  cmakeBuildType = "Release";
  separateDebugInfo = true;

  doCheck = false;

  env = {
    BUILD_BENCHMARKING = false;
  };
}
