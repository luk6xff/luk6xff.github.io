use std::env;
use std::fs;
use wc_tool_lib::process_content;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <file> [-l] [-w] [-c]", args[0]);
        std::process::exit(1);
    }

    let filename = &args[1];
    let content = fs::read_to_string(filename).unwrap_or_else(|err| {
        eprintln!("Error reading file '{}': {}", filename, err);
        std::process::exit(1);
    });

    let (lines, words, bytes) = process_content(&content);

    let mut show_lines = false;
    let mut show_words = false;
    let mut show_bytes = false;

    // If no options are provided, display all counts
    if args.len() == 2 {
        show_lines = true;
        show_words = true;
        show_bytes = true;
    } else {
        for arg in &args[2..] {
            match arg.as_str() {
                "-l" => show_lines = true,
                "-w" => show_words = true,
                "-c" => show_bytes = true,
                _ => {}
            }
        }
    }

    if show_lines {
        println!("Lines: {}", lines);
    }
    if show_words {
        println!("Words: {}", words);
    }
    if show_bytes {
        println!("Bytes: {}", bytes);
    }
}
