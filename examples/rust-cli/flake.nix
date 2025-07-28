{
  description = "Rust CLI Tool Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rustfmt" "clippy" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustToolchain
            cargo-watch
            cargo-edit
            cargo-audit
            cargo-outdated
            git
            curl
            wget
            jq
            tree
          ];
          
          shellHook = ''
            ${pkgs.coreutils}/bin/echo "🦀 Rust CLI Development Environment"
            ${pkgs.coreutils}/bin/echo "=================================="
            ${pkgs.coreutils}/bin/echo "Available tools:"
            ${pkgs.coreutils}/bin/echo "  - Rust: $(rustc --version)"
            ${pkgs.coreutils}/bin/echo "  - Cargo: $(cargo --version)"
            ${pkgs.coreutils}/bin/echo "  - Rustfmt: $(rustfmt --version)"
            ${pkgs.coreutils}/bin/echo "  - Clippy: $(cargo clippy --version)"
            ${pkgs.coreutils}/bin/echo ""
            ${pkgs.coreutils}/bin/echo "Useful commands:"
            ${pkgs.coreutils}/bin/echo "  cargo init          # Initialize new project"
            ${pkgs.coreutils}/bin/echo "  cargo build         # Build project"
            ${pkgs.coreutils}/bin/echo "  cargo run           # Run project"
            ${pkgs.coreutils}/bin/echo "  cargo test          # Run tests"
            ${pkgs.coreutils}/bin/echo "  cargo watch -x run  # Auto-reload on changes"
            ${pkgs.coreutils}/bin/echo "  cargo clippy        # Lint code"
            ${pkgs.coreutils}/bin/echo "  cargo fmt           # Format code"
          '';
        };
      });
}