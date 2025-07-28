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
            echo "🦀 Rust CLI Development Environment"
            echo "=================================="
            echo "Available tools:"
            echo "  - Rust: $(rustc --version)"
            echo "  - Cargo: $(cargo --version)"
            echo "  - Rustfmt: $(rustfmt --version)"
            echo "  - Clippy: $(cargo clippy --version)"
            echo ""
            echo "Useful commands:"
            echo "  cargo init          # Initialize new project"
            echo "  cargo build         # Build project"
            echo "  cargo run           # Run project"
            echo "  cargo test          # Run tests"
            echo "  cargo watch -x run  # Auto-reload on changes"
            echo "  cargo clippy        # Lint code"
            echo "  cargo fmt           # Format code"
          '';
        };
      });
}