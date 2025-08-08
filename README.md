# Cursor NixPkg

This repository contains an updated Nix package for [Cursor](https://cursor.com), an AI-powered code editor built on Visual Studio Code.

## Current Version

This package provides **Cursor 1.4.2**, which is newer than the version currently available in nixpkgs (1.3.9).

## Supported Platforms

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

## Installation

### Using Flakes (Recommended)

You can run Cursor directly without installing:

```bash
# Run from this directory
nix run .#cursor

# Or from a git repository (once published)
nix run github:yourusername/cursor-nixpkg
```

Or add it to your flake inputs:

```nix
{
  inputs = {
    cursor-nixpkg.url = "github:yourusername/cursor-nixpkg";
    # or from a local path:
    # cursor-nixpkg.url = "path:/home/mattw/Projects/misc/cursor-nixpkg";
  };
  
  outputs = { self, nixpkgs, cursor-nixpkg, ... }: {
    # Your configuration here
    environment.systemPackages = [
      cursor-nixpkg.packages.${system}.default
    ];
  };
}
```

### Using Legacy Nix

```bash
nix-build -A cursor
```

### Installing with Profile

```bash
nix profile install .#cursor
```

## Building Locally

1. Clone this repository
2. Run `nix build` to build the package
3. Run `nix run` to run Cursor directly

## Testing

To test that the package builds and works correctly:

```bash
./test.sh
```

This will:
1. Build the package
2. Verify the version is correct
3. Test that the binary is executable
4. Verify basic functionality

## Development

### Updating the Package

The package includes an update script that automatically fetches the latest version information from Cursor's API:

```bash
./update.sh
```

This script will:
1. Check the current version in the Cursor API
2. Download and calculate hashes for all supported platforms  
3. Update the package definition if a newer version is available

### Package Structure

- `flake.nix` - Flake configuration
- `package.nix` - Main package definition
- `update.sh` - Automated update script
- `README.md` - This documentation

## License

This package definition is provided under the same license as nixpkgs. Note that Cursor itself is proprietary software with an unfree license.

## Contributing

Feel free to contribute improvements to this package. The main areas for contribution are:

1. Keeping the version up to date
2. Testing on different platforms
3. Improving the update script
4. Documentation improvements

## Notes

- This package is marked as unfree due to Cursor's license
- You may need to enable unfree packages in your Nix configuration
- The package uses the official Cursor AppImage and DMG distributions
- VSCode version compatibility is maintained per the upstream package
