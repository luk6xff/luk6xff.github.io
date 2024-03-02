pub struct Car {
    speed: u32,     // speed in km/h
    fuel_used: f32, // fuel used in liters
    distance: u32,  // distance traveled in km
}

impl Car {
    pub fn new() -> Self {
        Car {
            speed: 0,
            fuel_used: 0.0,
            distance: 0,
        }
    }

    pub fn accelerate(&mut self, increase: u32) {
        self.speed += increase;
    }

    pub fn decelerate(&mut self, decrease: u32) {
        if decrease > self.speed {
            self.speed = 0;
        } else {
            self.speed -= decrease;
        }
    }

    pub fn get_speed(&self) -> u32 {
        self.speed
    }

    pub fn update_fuel_used(&mut self, fuel: f32) {
        self.fuel_used += fuel;
    }

    pub fn get_fuel_used(&self) -> f32 {
        self.fuel_used
    }

    pub fn update_distance(&mut self, distance: u32) {
        self.distance += distance;
    }

    pub fn get_distance(&self) -> u32
    {
        self.distance
    }

    pub fn calculate_fuelEfficiency(&self) -> f32 {
        if self.fuel_used == 0.0 {
            return 0.0;
        }
        (self.fuel_used / self.distance as f32) * 100.0
    }
}

fn main() {
    let mut car = Car::new();
    car.accelerate(20);
    car.update_fuel_used(5.0);
    car.update_distance(100);
    println!("Fuel efficiency: {:.2} litres per 100 km", car.calculate_fuelEfficiency());
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_accelerate() {
        let mut car = Car::new();
        car.accelerate(20);
        assert_eq!(car.get_speed(), 20);
    }

    #[test]
    fn test_decelerate() {
        let mut car = Car::new();
        car.accelerate(20);
        car.decelerate(10);
        assert_eq!(car.get_speed(), 10);
    }

    #[test]
    fn test_update_fuel_used() {
        let mut car = Car::new();
        car.update_fuel_used(5.0);
        assert_eq!(car.get_fuel_used(), 5.0);
    }

    #[test]
    fn test_update_distance() {
        let mut car = Car::new();
        car.update_distance(100);
        assert_eq!(car.get_distance(), 100);
    }

    #[test]
    fn test_efficiency_calculation() {
        let mut car = Car::new();
        car.update_distance(500);
        car.update_fuel_used(50.0);
        let result = car.calculate_fuelEfficiency();
        assert_eq!(result, 10.0);
    }

    #[test]
    fn test_efficiency_zero_fuel() {
        let mut car = Car::new();
        car.update_distance(500);
        let result = car.calculate_fuelEfficiency();
        assert_eq!(result, 0.0);
    }
}
