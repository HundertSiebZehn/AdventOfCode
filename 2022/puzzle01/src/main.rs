use std::fs;

fn main() {
    let input = fs::read_to_string("input1.txt")
        .expect("error with input file");
    //let split = collect(input.split("\n"));
    //println!("{}", input.clone());
    let split: Vec<&str> = input.split("\r\n").collect();
    let parsed = collect(split);
    let mut sums: Vec<i32> = parsed.iter().map(|numbers| numbers.iter().sum()).collect();
    let max = sums.iter().max().unwrap();
    println!("Part One: {}", max);
    sums.sort();
    sums.reverse();
    let max3: i32 = sums.iter().take(3).sum();
    println!("Part Two: {}", max3);
}

fn collect<'a>(values: Vec<&str>) -> Vec<Vec<i32>>
{
    let mut result: Vec<Vec<i32>> = Vec::new();
    result.push(Vec::new());
    for value in values {
        if value.eq("") {
            result.push(Vec::new());
        } else {
            let number: i32 = value.parse().expect("ignore1");
            result.last_mut().expect("ignore2").push(number);
        }
    }
    result
}
