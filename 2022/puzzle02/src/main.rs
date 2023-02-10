use std::{fs};

use std::str::FromStr;

#[derive(Debug, PartialEq, Eq)]
enum Fist {
    Rock,
    Paper,
    Scissors
}

impl Fist {
    fn score(&self, opponent: &Fist) -> u32 {
        let self_score: u32 = match self {
            Fist::Rock => 1,
            Fist::Paper => 2,
            Fist::Scissors => 3,
        };
        let win_score: u32= match (self, opponent) {
            (Fist::Rock, Fist::Rock) => 3,
            (Fist::Rock, Fist::Paper) => 0,
            (Fist::Rock, Fist::Scissors) => 6,
            (Fist::Paper, Fist::Rock) => 6,
            (Fist::Paper, Fist::Paper) => 3,
            (Fist::Paper, Fist::Scissors) => 0,
            (Fist::Scissors, Fist::Rock) => 0,
            (Fist::Scissors, Fist::Paper) => 6,
            (Fist::Scissors, Fist::Scissors) => 3,
        };
        return self_score + win_score;
    }
}
#[derive(Debug, PartialEq, Eq)]
struct ParseFistError;

impl FromStr for Fist {
    type Err = ParseFistError;

    fn from_str(s: &str) -> Result<Self, Self::Err>{
        match s {
            "A"| "X" => Ok(Fist::Rock),
            "B"| "Y"  => Ok(Fist::Paper),
            "C"| "Z" => Ok(Fist::Scissors),
            &_ => Err(ParseFistError),
        }
    }
}

#[derive(Debug, PartialEq, Eq)]
enum Outcome {
    Win,
    Lose,
    Draw,
}
impl Outcome {
    fn score(&self, opponent: &Fist) -> u32 {
        return match (self, opponent) {
            (Outcome::Win, Fist::Rock) => Fist::Paper,
            (Outcome::Win, Fist::Paper) => Fist::Scissors,
            (Outcome::Win, Fist::Scissors) => Fist::Rock,
            (Outcome::Lose, Fist::Paper) => Fist::Rock,
            (Outcome::Lose, Fist::Scissors) => Fist::Paper,
            (Outcome::Lose, Fist::Rock) => Fist::Scissors,
            (Outcome::Draw, Fist::Scissors) => Fist::Scissors,
            (Outcome::Draw, Fist::Paper) => Fist::Paper,
            (Outcome::Draw, Fist::Rock) => Fist::Rock,
        }.score(opponent);
    }
}
#[derive(Debug, PartialEq, Eq)]
struct ParseOutcomeError;

impl FromStr for Outcome {
    type Err = ParseOutcomeError;

    fn from_str(s: &str) -> Result<Self, Self::Err>{
        match s {
            "X" => Ok(Outcome::Lose),
            "Y"  => Ok(Outcome::Draw),
            "Z" => Ok(Outcome::Win),
            &_ => Err(ParseOutcomeError),
        }
    }
}

fn main() {
    let input = fs::read_to_string("input1.txt")
        .expect("error with input file");// */
    //let input = "A Y\r\nB X\r\nC Z";
    let split: Vec<&str> = input.split("\r\n").collect();
    //assert_eq!(split, vec!["A Y", "B X", "C Z"]);
    let pairs: Vec<Vec<&str>> = split.iter().map(|row|row.split(" ").collect()).collect::<Vec<Vec<&str>>>();
    //assert_eq!(pairs, vec![vec!["A", "Y"], vec!["B", "X"], vec!["C", "Z"]]);
    let tuples: Vec<(Fist, Outcome)> = pairs.iter().map(|pair| (Fist::from_str(pair[0]).expect("blub"), Outcome::from_str(pair[1]).expect("blab"))).collect();
    //assert_eq!(tuples, vec![(Fist::Rock, Outcome::Draw), (Fist::Paper, Outcome::Lose), (Fist::Scissors, Outcome::Win)]);
    let scores: Vec<u32> = tuples.iter().map(|(opponent, me)| me.score(opponent)).collect();
    //assert_eq!(scores, vec![4, 1, 7]);
    let sum: u32 = scores.iter().sum();
    //assert_eq!(sum, 12);
    println!("{}", sum);
}
/* part 1
fn main() {
    let input = fs::read_to_string("input1.txt")
        .expect("error with input file");// */
    //let input = "A Y\r\nB X\r\nC Z";
    /*let split: Vec<&str> = input.split("\r\n").collect();
    //assert_eq!(split, vec!["A Y", "B X", "C Z"]);
    let pairs: Vec<Vec<&str>> = split.iter().map(|row|row.split(" ").collect()).collect::<Vec<Vec<&str>>>();
    //assert_eq!(pairs, vec![vec!["A", "Y"], vec!["B", "X"], vec!["C", "Z"]]);
    let tuples: Vec<(Fist, Fist)> = pairs.iter().map(|pair| (Fist::from_str(pair[0]).expect("blub"), Fist::from_str(pair[1]).expect("blab"))).collect();
    //assert_eq!(tuples, vec![(Fist::Rock, Fist::Paper), (Fist::Paper, Fist::Rock), (Fist::Scissors, Fist::Scissors)]);
    let scores: Vec<u32> = tuples.iter().map(|(opponent, me)| me.score(opponent)).collect();
    //assert_eq!(scores, vec![8, 1, 6]);
    let sum: u32 = scores.iter().sum();
    //assert_eq!(sum, 15);
    println!("{}", sum);
}
*/

