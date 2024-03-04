#!/bin/sh

# Exit script on first error
set -e

# Check for subcommand
if [ "$#" -ne 1 ]; then
    echo "Usage: ./run.sh [run|test|lint|fix|fmt]"
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
        cargo audit
        ;;
    *)
        echo "Invalid subcommand: $SUBCOMMAND"
        echo "Usage: ./run.sh [test|lint|fix|fmt|audit]"
        exit 1
        ;;
esac
