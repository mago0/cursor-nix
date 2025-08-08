{
  pkgs,
  lib ? pkgs.lib,
}:

let
  # New version information
  version = "1.4.2";
  
  # Updated sources for all platforms
  sources = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/d01860bc5f5a36b62f8a77cd42578126270db343/linux/x64/Cursor-1.4.2-x86_64.AppImage";
      hash = "sha256-WMZA0CjApcSTup4FLIxxaO7hMMZrJPawYsfCXnFK4EE=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/d01860bc5f5a36b62f8a77cd42578126270db343/linux/arm64/Cursor-1.4.2-aarch64.AppImage";
      hash = "sha256-JuEu+QVz6b0iEz711mQSZ1UyVqFeFk6knQEjZxGr3+g=";
    };
    x86_64-darwin = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/d01860bc5f5a36b62f8a77cd42578126270db343/darwin/x64/Cursor-darwin-x64.dmg";
      hash = "sha256-TvPNU9GSNBvksEvwLcpirUu/rSc67bf00Usp+2T71lk=";
    };
    aarch64-darwin = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/d01860bc5f5a36b62f8a77cd42578126270db343/darwin/arm64/Cursor-darwin-arm64.dmg";
      hash = "sha256-AmNTIXQXdhnu31L5gtYGNFmICvGJkPRiz3yJJ0yw4kM=";
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
