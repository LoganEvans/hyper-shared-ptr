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

  shellHook = ''
    echo "To generate a flamegraph, run:"
    echo "    sudo sysctl -w kernel.perf_event_paranoid=1"
    echo "    runPhase configurePhase && runPhase buildPhase"
    echo "    perf record -F 99 -g -- benchmark/hyper-shared-ptr-benchmark"
    echo "    perf script | stackcollapse-perf.pl | flamegraph.pl > flamegraph.svg"
  '';
}
