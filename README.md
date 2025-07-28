# Development Environment Manager

An open-source project that uses Nix flakes to manage multi-language development environments with a CLI tool.

## Features

- 🔒 **Pinned Dependencies**: Lock Node.js, Python, Rust, PostgreSQL versions
- 🚀 **Quick Setup**: Prepare entire development environment with a single command
- 🔧 **CLI Tool**: Convenient command-line tools for project management
- 🌍 **Cross Platform**: Works on all systems that support Nix
- 👥 **Team Compatibility**: Ensures everyone works with the same dependencies

## Installation

### Prerequisites

1. Install Nix package manager:
   ```bash
   curl -L https://nixos.org/nix/install | sh
   ```

2. Enable Nix flakes:
   ```bash
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

### Using the Project

1. Clone this repository:
   ```bash
   git clone https://github.com/sw3do/dev-env-manager
   cd dev-env-manager
   ```

2. Enter development environment:
   ```bash
   nix develop
   ```

3. Use the CLI tool:
   ```bash
   dev-env-manager help
   ```

## Usage

### Creating a New Project

```bash
# Start a new project
dev-env-manager init my-awesome-project
cd my-awesome-project
nix develop
```

### Checking Environment Status

```bash
# Show current environment status
dev-env-manager status
```

### Viewing Dependency Versions

```bash
# List pinned versions
dev-env-manager versions
```

## Pinned Dependencies

- **Node.js**: 20.x
- **Python**: 3.11
- **Rust**: Latest stable
- **PostgreSQL**: 15.x
- **Additional Tools**: Git, curl, wget, jq, tree

## Project Structure

```
dev-env-manager/
├── flake.nix          # Main Nix flake configuration
├── README.md          # This file
├── LICENSE            # MIT license
└── .gitattributes     # Git configuration
```

## CLI Commands

| Command | Description |
|---------|-------------|
| `dev-env-manager init <name>` | Create new project |
| `dev-env-manager status` | Show environment status |
| `dev-env-manager versions` | List dependency versions |
| `dev-env-manager help` | Show help message |

## Example Usage Scenarios

### 1. Web Application Development

```bash
dev-env-manager init web-app
cd web-app
nix develop

# Start Node.js project
npm init -y
npm install express

# Add Python backend
python -m venv venv
source venv/bin/activate
pip install flask
```

### 2. Rust CLI Tool

```bash
dev-env-manager init rust-cli
cd rust-cli
nix develop

# Start Rust project
cargo init
cargo build
```

### 3. Full-Stack Project

```bash
dev-env-manager init fullstack-app
cd fullstack-app
nix develop

# Start PostgreSQL
pg_ctl -D ./postgres-data initdb
pg_ctl -D ./postgres-data start

# Frontend (Node.js)
npx create-react-app frontend

# Backend (Python)
mkdir backend
cd backend
python -m venv venv
source venv/bin/activate
pip install fastapi uvicorn
```

## Contributing

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

Use GitHub Issues for questions or problems.

## Advanced Usage

### Adding Custom Dependencies

You can add additional dependencies by editing the `flake.nix` file in generated projects:

```nix
buildInputs = with pkgs; [
  nodejs_20
  python311
  rustc
  cargo
  postgresql_15
  # Add new dependencies
  docker
  redis
  nginx
];
```

### Direnv Integration

Use direnv for automatic environment loading:

```bash
# Install direnv
nix-env -iA nixpkgs.direnv

# Add shell hook (.bashrc or .zshrc)
eval "$(direnv hook bash)"  # for bash
eval "$(direnv hook zsh)"   # for zsh

# In project directory
direnv allow
```

This way, the development environment will be automatically loaded when you enter the project directory.