#!/bin/bash
#set -x

# Function to display usage
usage() {
  echo "Usage: $0 [-b] [-s]" 1>&2
  echo "Options:" 1>&2
  echo "  -b    Build the blog site" 1>&2
  echo "  -s    Serve the blog site" 1>&2
  exit 1
}

# Parse command line options
while getopts ":bs" opt; do
  case ${opt} in
    b)
      echo "Start building the blog site..." 1>&2
      # Build the static other directories
      SECURE_RUST_BOOK_NAME="safe_secure_rust_book"
      mdbook build /app/content/other/${SECURE_RUST_BOOK_NAME} || { echo "Error: Failed to build ${SECURE_RUST_BOOK_NAME} mdbook" 1>&2; exit 1; }
      cp -r /app/content/other/${SECURE_RUST_BOOK_NAME}/book /app/static/other/${SECURE_RUST_BOOK_NAME}
      # Build the blog site
      zola build || { echo "Error: Failed to build blog site." 1>&2; exit 1; }
      ;;
    s)
      echo "Start serving the blog site..." 1>&2
      zola serve --interface 0.0.0.0 --port 8080 --base-url localhost || { echo "Error: Failed to serve blog site." 1>&2; exit 1; }
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." 1>&2
      usage
      ;;
  esac
done

shift $((OPTIND -1))
