use std::{str::FromStr, fs};

fn main() {
    part1();
    part2();
}

#[derive(Debug, PartialEq, Eq)]
struct Range {
    from: u32,
    till: u32,
}

impl Range {
    fn contains(&self, other: &Range) -> bool {
        self.from <= other.from && self.till >= other.till
    }

    fn overlaps(&self, other: &Range) -> bool {
        self.from <= other.till && self.till >= other.from
    }
}

#[derive(Debug, PartialEq, Eq)]
struct ParseRangeError;
impl FromStr for Range {
    type Err = ParseRangeError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut split = s.split('-');
        Ok(Range { 
            from: split.next().unwrap().parse().unwrap(),
            till: split.next().unwrap().parse().unwrap(),
        })
    }
}

fn part1() {
    let input = fs::read_to_string("input1.txt").unwrap();
    //let input = "2-4,6-8\r\n2-3,4-5\r\n5-7,7-9\r\n2-8,3-7\r\n6-6,4-6\r\n2-6,4-8";
    let count = input.split("\r\n")
        .map(|line| {
            let mut pairs = line.split(",");
            [
                Range::from_str(pairs.next().unwrap()).unwrap(),
                Range::from_str(pairs.next().unwrap()).unwrap(),
            ]
        })
        .filter(|[left, right]| left.contains(right) || right.contains(left))
        .count()
    ;
    println!("{}", count);
}

fn part2() {
    let input = fs::read_to_string("input1.txt").unwrap();
    //let input = "2-4,6-8\r\n2-3,4-5\r\n5-7,7-9\r\n2-8,3-7\r\n6-6,4-6\r\n2-6,4-8";
    let count = input.split("\r\n")
        .map(|line| {
            let mut pairs = line.split(",");
            [
                Range::from_str(pairs.next().unwrap()).unwrap(),
                Range::from_str(pairs.next().unwrap()).unwrap(),
            ]
        })
        .filter(|[left, right]| left.overlaps(right))
        .count()
    ;
    println!("{}", count);
}