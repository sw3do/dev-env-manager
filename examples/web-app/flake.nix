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
            ${pkgs.coreutils}/bin/echo "🌐 Web Application Development Environment"
            ${pkgs.coreutils}/bin/echo "========================================="
            ${pkgs.coreutils}/bin/echo "Available tools:"
            ${pkgs.coreutils}/bin/echo "  - Node.js: $(node --version)"
            ${pkgs.coreutils}/bin/echo "  - Python: $(python --version)"
            ${pkgs.coreutils}/bin/echo "  - PostgreSQL: $(postgres --version)"
            ${pkgs.coreutils}/bin/echo "  - Redis: $(redis-server --version)"
            ${pkgs.coreutils}/bin/echo ""
            ${pkgs.coreutils}/bin/echo "Quick start:"
            ${pkgs.coreutils}/bin/echo "  Frontend: npx create-react-app frontend"
            ${pkgs.coreutils}/bin/echo "  Backend: pip install fastapi uvicorn"
            ${pkgs.coreutils}/bin/echo "  Database: pg_ctl -D ./postgres-data initdb"
          '';
        };
      });
}