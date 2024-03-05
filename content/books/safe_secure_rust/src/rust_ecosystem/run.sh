#!/bin/sh

# Exit script on first error
set -e

# Check for subcommand
if [ "$#" -ne 1 ]; then
    echo "Usage: ./run.sh [run|test|lint|fix|fmt|audit|auditable]"
    exit 1
fi

SUBCOMMAND=$1

case $SUBCOMMAND in
    run)
        echo "Running application..."
        cargo run
        ;;
    test)
        echo "Running tests..."
        cargo test
        ;;
    lint)
        echo "Running clippy..."
        cargo clippy -- -D warnings
        ;;
    fix)
        echo "Running cargo fix..."
        #cargo fix --broken-code --allow-dirty --all-targets
        cargo clippy --fix
        ;;
    fmt)
        echo "Running rustfmt..."
        cargo fmt
        ;;
    audit)
        echo "Auditing dependencies..."
        cargo install cargo-audit --features=fix
        cargo audit
        cargo audit fix --dry-run
        ;;
    auditable)
        echo "Make Auditable binaries dependencies..."
        cargo install cargo-auditable
        cargo auditable build --release
        cargo audit bin target/release/car_project
        ;;
    *)
        echo "Invalid subcommand: $SUBCOMMAND"
        echo "Usage: ./run.sh [run|test|lint|fix|fmt|audit|auditable]"
        exit 1
        ;;
esac
