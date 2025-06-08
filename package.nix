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
clangStdenv.mkDerivation rec {
  inherit src;
  name = "hyper-shared-ptr";

  outputs = [
    "out"
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
    BUILD_BENCHMARK = false;
  };
}
