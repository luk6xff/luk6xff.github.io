## Rust example app, syntax overview

```rust,editable
use std::fmt::{self, Display, Formatter};
use std::sync::mpsc::{self, Receiver};
use std::thread;
use std::time::{Duration, Instant};

// Define an enum to represent the status of an sensor, showcasing Rust's enum and pattern matching.
enum SensorStatus {
    Running,
    Stopped,
    Error(String),
}

// Implement the Display trait for SensorStatus to enable easy printing.
impl Display for SensorStatus {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        match self {
            SensorStatus::Running => write!(f, "Sensor is running"),
            SensorStatus::Stopped => write!(f, "Sensor is stopped"),
            SensorStatus::Error(msg) => write!(f, "Sensor error: {}", msg),
        }
    }
}

// A struct representing a vehicle temperature sensor.
struct TemperatureSensor<'a> {
    name: &'a str,
    value: i32,
}

impl<'a> TemperatureSensor<'a> {
    const MIN_TEMP: i32 = -30;
    const MAX_TEMP: i32 = 150;
}

// A struct representing a vehicle speed sensor.
struct SpeedSensor<'a> {
    name: &'a str,
    value: u32,
}

impl<'a> SpeedSensor<'a> {
    const MAX_SPEED_LIMIT: u32 = 180;
}

// Implement the Display trait for Sensors, enabling descriptive output.
impl<'a> Display for TemperatureSensor<'a> {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "[{}] TemperatureSensor: {}", self.name, self.value)
    }
}

impl<'a> Display for SpeedSensor<'a> {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        write!(f, "[{}] SpeedSensor: {}", self.name, self.value)
    }
}

// Define a trait for diagnostic tools, demonstrating Rust's trait system for polymorphism.
trait DiagnosticTool {
    fn diagnose(&self) -> SensorStatus;
}

// Implement the DiagnosticTool trait for Sensors, showcasing trait implementations.
impl<'a> DiagnosticTool for TemperatureSensor<'a> {
    fn diagnose(&self) -> SensorStatus {
        if self.value > TemperatureSensor::MAX_TEMP {
            SensorStatus::Error(format!("{} sensor exceeds max limit:{} over {} [C]!", self.name, self.value, (self.value - TemperatureSensor::MAX_TEMP)))
        } else if self.value < TemperatureSensor::MIN_TEMP {
            SensorStatus::Error(format!("{} sensor reached below min limit:{} over {} [C]!", self.name, self.value, (self.value - TemperatureSensor::MIN_TEMP)))
        } else {
            SensorStatus::Running
        }
    }
}

impl<'a> DiagnosticTool for SpeedSensor<'a> {
    fn diagnose(&self) -> SensorStatus {
        if self.value > SpeedSensor::MAX_SPEED_LIMIT {
            SensorStatus::Error(format!("[{}] sensor exceeds max limit:{} over {} [km/h]!", self.name, self.value, (self.value - SpeedSensor::MAX_SPEED_LIMIT)))
        } else {
            SensorStatus::Running
        }
    }
}

// A function taking a dynamic trait object, demonstrating dynamic polymorphism.
fn run_diagnostic(tool: &dyn DiagnosticTool) -> SensorStatus {
    tool.diagnose()
}


// Define a struct for processing rear camera images, illustrating Rust's generic type parameters.
struct RearCameraImageProcessor<T> {
    data: T,
}

// Define a trait for image processing functionality.
trait ImageProcessing {
    fn process(&mut self);
}

// Implement methods for RearCameraImageProcessor, demonstrating ownership and borrowing.
impl<T: Display + Clone> RearCameraImageProcessor<T> {
    // Constructor method takes ownership of data.
    fn new(data: T) -> Self {
        RearCameraImageProcessor { data }
    }

    // Borrow self immutably to read data.
    fn read(&self) -> &T {
        &self.data
    }

    // Borrow self mutably to modify data.
    fn write(&mut self, data: T) {
        self.data = data;
    }
}

// Implement the ImageProcessing trait for RearCameraImageProcessor.
impl<T: Display + Clone> ImageProcessing for RearCameraImageProcessor<T> {
    // Sample processing method which just clones and displays the data.
    fn process(&mut self) {
        let processed_data = self.data.clone();
        println!("Processing image data: {}", processed_data);
    }
}

// Demonstrates the use of closures to modify data, showcasing Rust's closure capabilities.
fn adjust_brightness<F, T>(adjustment_closure: F, processor: &mut RearCameraImageProcessor<T>)
where
    F: Fn(T) -> T,
    T: Display + Clone,
{
    let current_data = processor.read().clone();
    println!("Current image brightness: {}", current_data);
    let adjusted_data = adjustment_closure(current_data);
    processor.write(adjusted_data);
}



fn main() {
    // Simulate a sensor that continuously sends data for 10 seconds.
    let (tx_temp, rx_temp): (mpsc::Sender<TemperatureSensor<'static>>, Receiver<TemperatureSensor<'static>>) = mpsc::channel();
    let (tx_speed, rx_speed): (mpsc::Sender<SpeedSensor<'static>>, Receiver<SpeedSensor<'static>>) = mpsc::channel();
    // Spawn a thread for the temp_sensor
    let tx_temp_clone = tx_temp.clone();
    thread::spawn(move || {
        let start = Instant::now();
        while start.elapsed() < Duration::new(10, 0) {
            let value = (start.elapsed().as_secs() * 10) as i32; // Simulate increasing temp
            let sensor = TemperatureSensor { name: "Engine Temperature", value: value };
            if let Err(e) = tx_temp_clone.send(sensor) {
                eprintln!("Error sending temp data: {}", e);
                break;
            }
            thread::sleep(Duration::from_millis(500)); // Simulate data sent every 500ms
        }
    });
    // Spawn a thread for the car_speed_sensor
    let tx_speed_clone = tx_speed.clone();
    thread::spawn(move || {
        let start = Instant::now();
        let mut factor: u64 = 1;
        while start.elapsed() < Duration::new(10, 0) {
            let value = (start.elapsed().as_secs() * 1 * factor) as u32; // Simulate increasing speed
            let sensor = SpeedSensor { name: "Car Speed", value: value };
            if let Err(e) = tx_speed_clone.send(sensor) {
                eprintln!("Error sending car speed data: {}", e);
                break;
            }
            factor = factor * 2;
            thread::sleep(Duration::from_millis(100)); // Simulate data sent every 100ms
        }
    });

    // Main thread acts as a diagnostic tool that processes sensors data
    let start = Instant::now();
    while start.elapsed() < Duration::new(10, 0) {
        if let Ok(sensor) = rx_temp.try_recv() {
            println!("Received {}: {}", sensor.name, sensor.value);
            // Here you can also run diagnostics on the received sensor data
            let status = run_diagnostic(&sensor);
            println!("Diagnostic result: {}", status);
        }
        if let Ok(sensor) = rx_speed.try_recv() {
            println!("Received {}: {}", sensor.name, sensor.value);
            // Here you can also run diagnostics on the received sensor data
            let status = run_diagnostic(&sensor);
            println!("Diagnostic result: {}", status);
        }
        // Simulate processing other tasks in the main thread
        thread::sleep(Duration::from_millis(100));
    }

    // Instantiate a RearCameraImageProcessor and demonstrate processing.
    let mut camera_processor = RearCameraImageProcessor::new("Initial image data".to_string());
    camera_processor.process();

    // Use a closure to adjust the brightness of the image data.
    adjust_brightness(|data| format!("{} + brightness adjusted", data), &mut camera_processor);
    println!("After adjustment: {}", camera_processor.read());

    println!("Simulation completed.");
}

```
