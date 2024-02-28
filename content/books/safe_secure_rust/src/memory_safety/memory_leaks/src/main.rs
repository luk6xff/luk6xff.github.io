fn is_limit_reached(speed_limit: i32) -> bool {

    let mut current_speed: i32 = 0;

    for factor in 0..100 {
        let ptr = Box::new(2); // Dynamically allocate memory with automatic deallocation
        current_speed += factor + *ptr;
    }

    let ptr = Box::new(10); // Dynamically allocate memory with automatic deallocation
    current_speed += *ptr;
    if current_speed > speed_limit {
        return true;
    }
    return false;
    // Memory pointed to by `ptr` is automatically deallocated here
}

fn main() {
    if is_limit_reached(120) {
        println!("Speed Limit exceeded.");
    }
}
