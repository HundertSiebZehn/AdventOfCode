use std::fs;

fn main() {
    part1();
    part2();
}

fn part1() {
    let input = fs::read_to_string("input.txt").unwrap().chars().collect::<Vec<char>>();
    //let input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb".chars().collect::<Vec<_>>();
    let index = find_index_of_first_unique_section(&input, 4);

    println!("{}", index);
}

fn is_unique(chars: &[char], n: usize) -> bool {
    for i in 0..chars.len() {
        for j in 1..n {
            if match chars.get(i + j) {
                Some(val) => chars[i] == *val,
                None => false,
            } {
                return false;
            }
        }
    }
    true
}

fn find_index_of_first_unique_section(chars: &Vec<char>, size: usize) -> usize {
    return chars.windows(size)
        .enumerate()
        .map(|(i, chars)| {
            if !is_unique(chars, size) {
                //println!("{:?}: None", chars);
                return None;
            }

            //println!("{:?}: {}", chars, i);
            return Some(i);
        })
        .skip_while(|option| option.is_none())
        .next().unwrap().unwrap() + size;
}

fn part2() {
    let input = fs::read_to_string("input.txt").unwrap().chars().collect::<Vec<char>>();
    //let input = "mjqjpqmgbljsphdztnvjfqwrcgsmlb".chars().collect::<Vec<_>>();
    let index = find_index_of_first_unique_section(&input, 14);

    println!("{}", index);
}