from typing import List, Literal, Tuple
from os import path
import sys


class Submarine():
    def __init__(self) -> None:
        self.pos = 0
        self.depth = 0

    def move(self, cmd: Literal['forward', 'down', 'up'], delta):
        if cmd == 'forward':
            self.pos += delta
        elif cmd == 'down':
            self.depth += delta
        elif cmd == 'up':
            self.depth -= delta

    def result(self) -> int:
        return self.pos * self.depth

def getFilePathFromArgs(args: List[str])->str:
    if len(args) != 1: 
        raise ValueError("input file not found.")
    inputFile = args[0]
    if not path.exists(inputFile): 
        raise ValueError(f"'{inputFile}' was not found.")
    
    return inputFile

def getInstructions(filePath: str) -> List[Tuple[str, int]]:
    with open(filePath, 'r') as file:
        content = file.readlines()
        return list(
            map(
                lambda x: (x[0], int(x[1]))
                , map(
                    lambda line: line.split(' '),
                    content
                )
            )
        )


def main(args: List[str]):
    file = getFilePathFromArgs(args)
    instructions = getInstructions(file)
    sub = Submarine()
    for cmd, delta in instructions:
        sub.move(cmd, delta)
    
    print(f"final position: {sub.pos}, depth: {sub.depth}")
    print(f"result: {sub.result()}")


if __name__ == '__main__':
    main(sys.argv[1::])
