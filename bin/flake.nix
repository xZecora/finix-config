{
  description = "A flake for my shell scripts";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      packages.x86_64-linux = {
        screenshot = pkgs.callPackage ./screenshot.nix { };
        greek = pkgs.callPackage ./greek.nix { };
      };
    };
}
