from typing import Optional, List, Tuple, Union
from os import path
import sys
import re

class VentMap():
    def __init__(self, size: int) -> None:
        self.map: List[List[int]] = [list([0] * size) for _ in range(size)]

    def markLine(self, line: Tuple[Tuple[int, int],Tuple[int, int]])->None:
        start, end = line
        x1, y1 = start
        x2, y2 = end
        #print(f"marking from ({x1}, {y1}) to ({x2}, {y2})")
        if x1 == x2:
            for y in range(min(y1, y2), max(y1, y2) + 1):
                self.mark(x1, y)
        if y1 == y2:
            for x in range(min(x1, x2), max(x1, x2) + 1):
                self.mark(x, y1)
        #print(self)

    def mark(self, x: int, y: int)->None:
        #print(f"marking ({x}, {y})")
        self.map[y][x] += 1

    @property
    def score(self)->int:
        return sum(map(
            lambda line: sum(map(lambda p: 1 if p >= 2 else 0, line)),
            self.map
        ))

    def __repr__(self) -> str:
        return self.__class__.__name__ + '(\n' + '\n'.join(map(lambda line: ''.join(map(str, line)), self.map)) + '\n)\n'

def getLineDefiniotns(lines: List[str])-> List[Tuple[Tuple[int, int], Tuple[int, int]]]:
    return list(map(
        lambda line: tuple(map(
            lambda coord: tuple(map(int, coord.strip().split(','))),
            line.split('->')
        )),
        lines
    ))

def getLinesFromFromArgsPath(args: List[str]) -> List[str]:
    if len(args) != 1:
        raise ValueError("input file not found.")
    inputFile = args[0]
    if not path.exists(inputFile):
        raise ValueError(f"'{inputFile}' was not found.")

    with open(inputFile, 'r') as file:
        return file.readlines()

def main(args: List[str]):
    lines = getLinesFromFromArgsPath(args)
    lines = getLineDefiniotns(lines)
    size = max(map(lambda line: max(line[0][0], line[0][1], line[1][0], line[1][1]), lines))
    vents = VentMap(size + 1)
    print(size)
    for line in lines:
        vents.markLine(line)
    
    print(f"at least {vents.score} points with overlapping lines")

if __name__ == '__main__':
    main(sys.argv[1::])
