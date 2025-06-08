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

        treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;

        drv = pkgs.callPackage ./package.nix {
          src = self;
          theta-debug-utils = pkg-theta-debug-utils;
        };
      in
      {
        packages = rec {
          hyper-shared-ptr = drv;

          benchmark = drv.overrideAttrs (old-attrs: {
            doCheck = true;
            env.BUILD_BENCHMARK = true;
          });

          default = hyper-shared-ptr;
        };

        devShells = {
          default = drv.overrideAttrs (old-attrs: {
            cmakeBuildType = "Debug";
            doCheck = true;
            env.BUILD_BENCHMARK = true;
          });
        };

        formatter = (pkgs: treefmtEval.config.build.wrapper) { };
      }
    );
}
