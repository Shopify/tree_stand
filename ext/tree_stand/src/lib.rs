use magnus::{define_global_function, function};

fn distance(a: (f64, f64), b: (f64, f64)) -> f64 {
    ((b.0 - a.0).powi(2) + (b.1 - a.1).powi(2)).sqrt()
}

#[magnus::init]
fn init() {
    define_global_function("distance", function!(distance, 2));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_distance() {
        assert_eq!(distance((0.0, 0.0), (3.0, 4.0)), 5.0);
    }

}
