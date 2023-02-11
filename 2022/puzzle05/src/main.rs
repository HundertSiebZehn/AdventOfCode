use std::fs;

fn main() {
    part1();
    part2();
}

fn part1(){
    //let input = "    [D]    \r\n[N] [C]    \r\n[Z] [M] [P]\r\n    1   2   3 \r\n\r\nmove 1 from 2 to 1\r\nmove 3 from 1 to 3\r\nmove 2 from 2 to 1\r\nmove 1 from 1 to 2";
    let input = fs::read_to_string("input1.txt").unwrap();
    let mut split = input.split("\r\n\r\n");
    let stacks_input = split.next().unwrap();
    let instructions_input = split.next().unwrap();
    assert_eq!(split.next(), None);
    let stack_count = (stacks_input.split("\r\n").next().unwrap().len() + 1) / 4;
    let mut stacks = vec![0; stack_count]
                                .iter()
                                .map(|_|Vec::new())
                                .collect::<Vec<Vec<char>>>();
    for layer in stacks_input.split("\r\n") {
        for (i, stack) in layer.chars().collect::<Vec<char>>().chunks(4).enumerate(){
            if stack[0] == ' ' {
                continue;
            }
            if stack[0] == '1' {
                break;
            }
            stacks[i].insert(0, stack[1]);
        }
    }
    // println!("start: {:?}", stacks);

    for instruction in instructions_input.split("\r\n") {
        let mut parts = instruction.splitn(6, ' ');
        assert_eq!(parts.next().unwrap(), "move");
        let count = parts.next().unwrap().parse::<i32>().unwrap();
        assert_eq!(parts.next().unwrap(), "from");
        let from= parts.next().unwrap().parse::<usize>().unwrap() - 1;
        assert_eq!(parts.next().unwrap(), "to");
        let to= parts.next().unwrap().parse::<usize>().unwrap() - 1;
        assert_eq!(parts.next(), None);
        for _ in 0..count {
            let elem = stacks[from].pop().unwrap();
            stacks[to].push(elem);
        }
        // println!("moved {} from {} to {}: {:?}", count, from + 1, to + 1, stacks);
    }

    let result = stacks.iter().map(|stack| stack.last().unwrap()).collect::<String>();
    println!("{}", result);

}

fn part2() {

    //let input = "    [D]    \r\n[N] [C]    \r\n[Z] [M] [P]\r\n    1   2   3 \r\n\r\nmove 1 from 2 to 1\r\nmove 3 from 1 to 3\r\nmove 2 from 2 to 1\r\nmove 1 from 1 to 2";
    let input = fs::read_to_string("input1.txt").unwrap();
    let mut split = input.split("\r\n\r\n");
    let stacks_input = split.next().unwrap();
    let instructions_input = split.next().unwrap();
    assert_eq!(split.next(), None);
    let stack_count = (stacks_input.split("\r\n").next().unwrap().len() + 1) / 4;
    let mut stacks = vec![0; stack_count]
                                .iter()
                                .map(|_|Vec::new())
                                .collect::<Vec<Vec<char>>>();
    for layer in stacks_input.split("\r\n") {
        for (i, stack) in layer.chars().collect::<Vec<char>>().chunks(4).enumerate(){
            if stack[0] == ' ' {
                continue;
            }
            if stack[0] == '1' {
                break;
            }
            stacks[i].insert(0, stack[1]);
        }
    }
    // println!("start: {:?}", stacks);

    for instruction in instructions_input.split("\r\n") {
        let mut parts = instruction.splitn(6, ' ');
        assert_eq!(parts.next().unwrap(), "move");
        let count = parts.next().unwrap().parse::<i32>().unwrap();
        assert_eq!(parts.next().unwrap(), "from");
        let from= parts.next().unwrap().parse::<usize>().unwrap() - 1;
        assert_eq!(parts.next().unwrap(), "to");
        let to= parts.next().unwrap().parse::<usize>().unwrap() - 1;
        assert_eq!(parts.next(), None);
        let mut elems = Vec::new();
        for _ in 0..count {
            elems.insert(0, stacks[from].pop().unwrap());
        }
        stacks[to].append(&mut elems);
        // println!("moved {} from {} to {}: {:?}", count, from + 1, to + 1, stacks);
    }

    let result = stacks.iter().map(|stack| stack.last().unwrap()).collect::<String>();
    println!("{}", result);
}