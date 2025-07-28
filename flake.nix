{
  description = "Development Environment Manager - Multi-language development environment with pinned dependencies";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        nodejs = pkgs.nodejs_20;
        python = pkgs.python311;
        rust = pkgs.rustc;
        cargo = pkgs.cargo;
        postgresql = pkgs.postgresql_15;
        
        pythonEnv = python.withPackages (ps: with ps; [
          pip
          setuptools
          wheel
          virtualenv
        ]);
        
        devEnvManager = pkgs.writeShellScriptBin "dev-env-manager" ''
          #!/usr/bin/env bash
          
          set -e
          
          COMMAND="$1"
          PROJECT_NAME="$2"
          
          show_help() {
            echo "Development Environment Manager"
            echo "Usage: dev-env-manager <command> [options]"
            echo ""
            echo "Commands:"
            echo "  init <project-name>    Initialize a new project with flake.nix"
            echo "  status                 Show current environment status"
            echo "  versions               Show pinned dependency versions"
            echo "  help                   Show this help message"
            echo ""
            echo "Examples:"
            echo "  dev-env-manager init my-project"
            echo "  dev-env-manager status"
            echo "  dev-env-manager versions"
          }
          
          show_status() {
            echo "🔧 Development Environment Status"
            echo "================================="
            echo "Node.js: $(node --version 2>/dev/null || echo 'Not available')"
            echo "Python: $(python --version 2>/dev/null || echo 'Not available')"
            echo "Rust: $(rustc --version 2>/dev/null || echo 'Not available')"
            echo "Cargo: $(cargo --version 2>/dev/null || echo 'Not available')"
            echo "PostgreSQL: $(postgres --version 2>/dev/null || echo 'Not available')"
            echo "Git: $(git --version 2>/dev/null || echo 'Not available')"
            echo ""
            if [ -f "flake.nix" ]; then
              echo "✅ flake.nix found in current directory"
            else
              echo "❌ flake.nix not found in current directory"
            fi
          }
          
          show_versions() {
            echo "📦 Pinned Dependency Versions"
            echo "============================="
            echo "Node.js: ${nodejs.version}"
            echo "Python: ${python.version}"
            echo "Rust: ${rust.version}"
            echo "PostgreSQL: ${postgresql.version}"
            echo "Nix: $(nix --version)"
          }
          
          init_project() {
            if [ -z "$PROJECT_NAME" ]; then
              echo "❌ Error: Project name is required"
              echo "Usage: dev-env-manager init <project-name>"
              exit 1
            fi
            
            if [ -d "$PROJECT_NAME" ]; then
              echo "❌ Error: Directory '$PROJECT_NAME' already exists"
              exit 1
            fi
            
            echo "🚀 Initializing project: $PROJECT_NAME"
            mkdir -p "$PROJECT_NAME"
            cd "$PROJECT_NAME"
            
            cat > flake.nix << 'EOF'
{
  description = "Development environment for PROJECT_NAME_PLACEHOLDER";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.\${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            python311
            rustc
            cargo
            postgresql_15
            git
            curl
            wget
            jq
            tree
          ];
          
          shellHook = ''
            echo "🎉 Welcome to PROJECT_NAME_PLACEHOLDER development environment!"
            echo "Available tools:"
            echo "  - Node.js: \$(node --version)"
            echo "  - Python: \$(python --version)"
            echo "  - Rust: \$(rustc --version)"
            echo "  - PostgreSQL: \$(postgres --version)"
            echo ""
            echo "Run 'dev-env-manager status' to check environment status"
            echo "Run 'dev-env-manager help' for more commands"
          '';
        };
      });
}
EOF
            
            sed -i "" "s/PROJECT_NAME_PLACEHOLDER/$PROJECT_NAME/g" flake.nix
            
            cat > .envrc << 'EOF'
use flake
EOF
            
            cat > README.md << EOF
# $PROJECT_NAME

This project uses Nix flakes for reproducible development environments.

## Quick Start

1. Make sure you have Nix installed with flakes enabled
2. Run \`nix develop\` to enter the development environment
3. All dependencies will be automatically available

## Available Tools

- Node.js 20
- Python 3.11
- Rust (latest)
- PostgreSQL 15
- Git, curl, wget, jq, tree

## Development

\`\`\`bash
# Enter development environment
nix develop

# Check environment status
dev-env-manager status

# Show dependency versions
dev-env-manager versions
\`\`\`
EOF
            
            echo "✅ Project '$PROJECT_NAME' initialized successfully!"
            echo "📁 Created directory: $PROJECT_NAME"
            echo "📄 Created files: flake.nix, .envrc, README.md"
            echo ""
            echo "Next steps:"
            echo "  cd $PROJECT_NAME"
            echo "  nix develop"
          }
          
          case "$COMMAND" in
            "init")
              init_project
              ;;
            "status")
              show_status
              ;;
            "versions")
              show_versions
              ;;
            "help" | "--help" | "-h" | "")
              show_help
              ;;
            *)
              echo "❌ Unknown command: $COMMAND"
              echo "Run 'dev-env-manager help' for usage information"
              exit 1
              ;;
          esac
        '';
        
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs
            pythonEnv
            rust
            cargo
            postgresql
            git
            curl
            wget
            jq
            tree
            devEnvManager
          ];
          
          shellHook = ''
            echo "🎉 Welcome to Development Environment Manager!"
            echo "============================================="
            echo "Available tools:"
            echo "  - Node.js: $(node --version)"
            echo "  - Python: $(python --version)"
            echo "  - Rust: $(rustc --version)"
            echo "  - PostgreSQL: $(postgres --version)"
            echo ""
            echo "CLI Tool: dev-env-manager"
            echo "Run 'dev-env-manager help' to get started"
            echo ""
            echo "Example usage:"
            echo "  dev-env-manager init my-awesome-project"
            echo "  dev-env-manager status"
            echo "  dev-env-manager versions"
          '';
        };
        
        packages.default = devEnvManager;
        
        apps.default = {
          type = "app";
          program = "${devEnvManager}/bin/dev-env-manager";
        };
      });
}