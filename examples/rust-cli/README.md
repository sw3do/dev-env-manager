# Rust CLI Tool Example

This example provides an environment optimized for developing CLI tools with Rust.

## Included Tools

- **Rust**: Latest stable version
- **Cargo**: Rust package manager
- **Rustfmt**: Code formatting
- **Clippy**: Lint tool
- **Cargo Extensions**:
  - `cargo-watch`: Automatic recompilation
  - `cargo-edit`: Dependency management
  - `cargo-audit`: Security audit
  - `cargo-outdated`: Check outdated dependencies

## Quick Start

```bash
# Enter development environment
nix develop

# Create new Rust project
cargo init my-cli-tool
cd my-cli-tool

# Run the project
cargo run

# Run tests
cargo test

# Format code
cargo fmt

# Lint check
cargo clippy
```

## Example CLI Tool

```rust
// src/main.rs
use std::env;
use std::process;

fn main() {
    let args: Vec<String> = env::args().collect();
    
    if args.len() < 2 {
        eprintln!("Usage: {} <command>", args[0]);
        process::exit(1);
    }
    
    match args[1].as_str() {
        "hello" => println!("Hello, World!"),
        "version" => println!("v1.0.0"),
        "help" => print_help(),
        _ => {
            eprintln!("Unknown command: {}", args[1]);
            process::exit(1);
        }
    }
}

fn print_help() {
    println!("Available commands:");
    println!("  hello   - Print hello message");
    println!("  version - Show version");
    println!("  help    - Show this help");
}
```

## Example Cargo.toml

```toml
[package]
name = "my-cli-tool"
version = "0.1.0"
edition = "2021"

[dependencies]
clap = { version = "4.0", features = ["derive"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tokio = { version = "1.0", features = ["full"] }

[[bin]]
name = "my-cli-tool"
path = "src/main.rs"
```

## Development Workflow

```bash
# Development with automatic recompilation
cargo watch -x run

# Add new dependency
cargo add clap

# Remove dependency
cargo rm unused-dep

# Security audit
cargo audit

# Check outdated dependencies
cargo outdated

# Release build
cargo build --release
```

## Writing Tests

```rust
// src/lib.rs
pub fn add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
```

## Popular CLI Libraries

- **clap**: Command line argument parsing
- **serde**: Serialization/deserialization
- **tokio**: Async runtime
- **reqwest**: HTTP client
- **anyhow**: Error handling
- **log/env_logger**: Logging
- **crossterm**: Terminal manipulation