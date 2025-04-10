fn main() {
    println!("Hello, world!");
    println!("{}", add(1, 2));
    let mut a : i32 = add(1, 2);
    a = add(add(a, a), 2);
    println!("{}", a);
}

fn add(a: i32, b: i32) -> i32 {
    return a + b
}
