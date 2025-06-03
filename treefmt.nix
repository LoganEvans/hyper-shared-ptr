{ pkgs, ... }:
{
  projectRootFile = "flake.nix";

  programs.clang-format.enable = true;
  programs.cmake-format.enable = true;
  programs.cmake-format.includes = [ "*CMakeLists.txt" ];
  programs.nixfmt.enable = true;
}
