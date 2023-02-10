use std::{fs, str::FromStr};

#[derive(Debug, PartialEq, Eq)]
struct Rucksack {
    first: Vec<char>,
    second: Vec<char>,
}

impl Rucksack {
    fn find_error(&self) -> Option<char> {
        for c in self.first.iter() {
            if self.second.contains(c) {
                return Some(*c);
            }
        }
        None
    }
}

#[derive(Debug, PartialEq, Eq)]
struct ParseRucksackError;

impl FromStr for Rucksack {
    type Err = ParseRucksackError;

    fn from_str(s: &str) -> Result<Self, Self::Err>{
        let all_chars: Vec<char> = s.chars().collect();
        let mut chunks = all_chars.chunks(s.len() / 2);
        Ok(Rucksack { first: chunks.next().unwrap().to_vec(), second: chunks.next().unwrap().to_vec()})
    }
}

fn error_to_prio(c: char) -> u32 {
    if c.is_lowercase() {
        //println!("{}: {:3}-{:3}={:3}", c, c as u32, 'a' as u32, c as u32 - 'a' as u32);
        return c as u32 - 'a' as u32 + 1;
    } else {
        //println!("{}: {:3}-{:3}={:3}", c, c as u32, 'A' as u32, c as u32 - 'A' as u32);
        return c as u32 - 'A' as u32 + 27;
    }
}

fn main() {
    part1();
    println!("-----------------");
    part2();
}

fn part1() {
    let input = fs::read_to_string("input1.txt").expect("error with input file");
    //let input = "vJrwpWtwJgWrhcsFMMfFFhFp\r\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\r\nPmmdzqPrVvPwwTWBwg\r\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\r\nttgJtRGJQctTZtZT\r\nCrZsJsPPZsGzwwsLwLmpwMDw";
    let rucksacks = input.split("\r\n").collect::<Vec<_>>().iter().map(|r| Rucksack::from_str(r).unwrap()).collect::<Vec<_>>();
    //Rucksack::from_str(input).unwrap();
    /*assert_eq!(rucksacks, vec![
        Rucksack{first: "vJrwpWtwJgWr".chars().collect(), second: "hcsFMMfFFhFp".chars().collect()},
        Rucksack{first: "jqHRNqRjqzjGDLGL".chars().collect(), second: "rsFMfFZSrLrFZsSL".chars().collect()},
        Rucksack{first: "PmmdzqPrV".chars().collect(), second: "vPwwTWBwg".chars().collect()},
        Rucksack{first: "wMqvLMZHhHMvwLH".chars().collect(), second: "jbvcjnnSBnvTQFn".chars().collect()},
        Rucksack{first: "ttgJtRGJ".chars().collect(), second: "QctTZtZT".chars().collect()},
        Rucksack{first: "CrZsJsPPZsGz".chars().collect(), second: "wwsLwLmpwMDw".chars().collect()},
    ]);// */
    let errors = rucksacks.iter().map(|ruck| ruck.find_error().unwrap()).collect::<Vec<_>>();
    //assert_eq!(errors, vec!['p', 'L', 'P', 'v', 't', 's']);
    let prios = errors.iter().map(|err| error_to_prio(*err)).collect::<Vec<u32>>();
    //assert_eq!(prios, vec![16, 38, 42, 22, 20, 19]);
    let sum = prios.iter().sum::<u32>();
    println!("{}", sum);
}

#[derive(Debug, PartialEq, Eq)]
struct RucksackGroup {
    first: Vec<char>,
    second: Vec<char>,
    third: Vec<char>,
}

impl RucksackGroup {
    fn find_badge(&self) -> Option<char> {
        for c in self.first.iter() {
            if self.second.contains(c) && self.third.contains(c) {
                return Some(*c);
            }
        }
        None
    }
}

#[derive(Debug, PartialEq, Eq)]
struct ParseRucksackGroupError;

impl From<&[Vec<char>; 3]> for RucksackGroup {
    fn from(chunks: &[Vec<char>; 3]) -> Self {
        RucksackGroup {
            first: chunks[0].clone(),
            second: chunks[1].clone(),
            third: chunks[2].clone(),
        }
    }
}// */

fn part2() {
    let input = fs::read_to_string("input1.txt").expect("error with input file");
    //let input = "vJrwpWtwJgWrhcsFMMfFFhFp\r\njqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL\r\nPmmdzqPrVvPwwTWBwg\r\nwMqvLMZHhHMvwLHjbvcjnnSBnvTQFn\r\nttgJtRGJQctTZtZT\r\nCrZsJsPPZsGzwwsLwLmpwMDw";
    let parsed = input.split("\r\n").collect::<Vec<_>>().iter()
        .map(|line| line.chars().collect::<Vec<_>>()).collect::<Vec<Vec<char>>>()
        .chunks(3).map(|chunk| [chunk[0].clone(), chunk[1].clone(), chunk[2].clone()]).collect::<Vec<[Vec<char>; 3]>>();
    
    let groups = parsed.iter().map(|group| RucksackGroup::from(group));
    let sum: u32 = groups.map(|g| error_to_prio(g.find_badge().unwrap())).sum();
    println!("{}", sum);
}