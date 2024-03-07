// This will be fuzzed
pub fn process_content(content: &str) -> (usize, usize, usize) {
    let lines = content.lines().count();
    let words = content.split_whitespace().count();
    let bytes = content.as_bytes().len();
    // Simluate an issue for fuzzer
    if bytes > 1000 {
        panic!("Simulating an error");
    }
    (lines, words, bytes)
}
