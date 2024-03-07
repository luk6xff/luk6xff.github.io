#![no_main]

use libfuzzer_sys::fuzz_target;
use wc_tool_lib::process_content;

fuzz_target!(|data: &[u8]| {
    if let Ok(content) = std::str::from_utf8(data) {
        let _ = process_content(content);
    }
});
