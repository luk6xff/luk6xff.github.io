#[macro_use]
extern crate afl;
use wc_tool_lib::process_content;

fn main() {
    fuzz!(|data: &[u8]| {
        if let Ok(content) = std::str::from_utf8(data) {
            let _ = process_content(content);
        }
    });
}
