{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    theta-debug-utils = {
      url = "github:LoganEvans/debug-utils";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      theta-debug-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pkg-theta-debug-utils = theta-debug-utils.packages.${system}.default;

        hyper-shared-ptr-drv = pkgs.callPackage ./package.nix {
          theta-debug-utils = pkg-theta-debug-utils;
          src = self;
        };

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
      in
      {
        packages = rec {
          hyper-shared-ptr = hyper-shared-ptr-drv;
          default = hyper-shared-ptr-drv;
        };

        devShells = {
          benchmark = hyper-shared-ptr-drv.overrideAttrs (old-attrs: {
            cmakeBuildType = "RelWithDebInfo";
            doCheck = true;
            env.BUILD_BENCHMARKING = true;
          });

          default = hyper-shared-ptr-drv.overrideAttrs (old-attrs: {
            cmakeBuildType = "Debug";
            doCheck = true;
            env.BUILD_BENCHMARKING = true;
          });
        };

        formatter = (pkgs: treefmtEval.config.build.wrapper) { };
      }
    );
}
