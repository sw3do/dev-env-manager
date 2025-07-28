{
  description = "Web Application Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_20
            python311
            postgresql_15
            redis
            git
            curl
            wget
            jq
            tree
          ];
          
          shellHook = ''
            echo "🌐 Web Application Development Environment"
            echo "========================================="
            echo "Available tools:"
            echo "  - Node.js: $(node --version)"
            echo "  - Python: $(python --version)"
            echo "  - PostgreSQL: $(postgres --version)"
            echo "  - Redis: $(redis-server --version)"
            echo ""
            echo "Quick start:"
            echo "  Frontend: npx create-react-app frontend"
            echo "  Backend: pip install fastapi uvicorn"
            echo "  Database: pg_ctl -D ./postgres-data initdb"
          '';
        };
      });
}