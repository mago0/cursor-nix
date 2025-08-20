{
  description = "Cursor AI-powered code editor - version 1.4.5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        
        cursor = pkgs.callPackage ./package.nix { inherit pkgs; };
        
      in {
        packages = {
          default = cursor;
          cursor = cursor;
        };

        apps = {
          default = {
            type = "app";
            program = "${cursor}/bin/cursor";
          };
        };
      });
}
