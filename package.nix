{
  pkgs,
  lib ? pkgs.lib,
}:

let
  # New version information
  version = "1.4.5";
  
  # Updated sources for all platforms
  sources = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/af58d92614edb1f72bdd756615d131bf8dfa5299/linux/x64/Cursor-1.4.5-x86_64.AppImage";
      hash = "sha256-2Hz1tXC+YkIIHWG1nO3/84oygH+wvaUtTXqvv19ZAz4=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/af58d92614edb1f72bdd756615d131bf8dfa5299/linux/arm64/Cursor-1.4.5-aarch64.AppImage";
      hash = "sha256-kKoOSxLsgeM2FJRW2HlCinhz6Ij6lpVsbWxQmTiMBSs=";
    };
    x86_64-darwin = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/af58d92614edb1f72bdd756615d131bf8dfa5299/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-fX8ukEWKS2prNz+UopZ9a4uhDLoGYuXa6P8cSJqBang=";
    };
    aarch64-darwin = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/af58d92614edb1f72bdd756615d131bf8dfa5299/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-J/by3BOoIV2HUtcCqaCEJoPzqcFFooc/zShSmEBSw/Q=";
    };
  };
  
  # Get the existing code-cursor package
  originalCursor = pkgs.code-cursor;
  
in
# Override the existing package with new sources and version
originalCursor.overrideAttrs (oldAttrs: {
  inherit version;
  
  # Update sources
  passthru = (oldAttrs.passthru or {}) // {
    inherit sources;
  };
  
  # Update the src based on platform
  src = 
    if pkgs.stdenv.hostPlatform.isLinux then
      pkgs.appimageTools.extract {
        pname = "cursor";
        inherit version;
        src = sources.${pkgs.stdenv.hostPlatform.system};
      }
    else
      sources.${pkgs.stdenv.hostPlatform.system};
      
  sourceRoot = 
    if pkgs.stdenv.hostPlatform.isLinux then 
      "cursor-${version}-extracted/usr/share/cursor" 
    else 
      "Cursor.app";
})
