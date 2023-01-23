from typing import Optional, List, Union
from os import path
import sys
import re


class BingoBoard():
    def __init__(self, lines: List[str]) -> None:
        self.board: List[List[Union[int, None]]] = BingoBoard._parse(lines)

    @staticmethod
    def _parse(lines: List[str]) -> List[List[int]]:
        if len(lines) != 5:
            raise ValueError(f"expect 5 lines, got {len(lines)}")

        return list(map(lambda line: list(map(int, re.split('\s+', line.strip()))), lines))

    def mark(self, called: int) -> Optional[int]:
        for y, row in enumerate(self.board):
            for x, value in enumerate(row):
                if value == called:
                    self.board[y][x] = None
        if self.isWon:
            return self._score(called)
        return None

    @property
    def isWon(self) -> bool:
        countNones = lambda xs: len(list(filter(lambda x: x is None, xs)))
        return 5 in map(countNones, self.board) or \
            5 in map(countNones, zip(*self.board))

    def _score(self, called: int) -> int:
        return sum(map(lambda row: sum(filter(None, row)), self.board)) * called

    def __repr__(self) -> str:
        return f"Board({repr(self.board)})"


def getFilePathFromArgs(args: List[str]) -> str:
    if len(args) != 1:
        raise ValueError("input file not found.")
    inputFile = args[0]
    if not path.exists(inputFile):
        raise ValueError(f"'{inputFile}' was not found.")

    return inputFile


def main(args: List[str]):
    filePath = getFilePathFromArgs(args)
    boards: List[BingoBoard] = []
    with open(filePath, 'r') as file:
        lines = file.readlines()
        drawnNumbers = list(map(int, lines[0].split(',')))
        for i in range(0, len(lines)-2, 6):
            boards.append(BingoBoard(lines[2+i: 2+i+5]))
    
    for drawn in drawnNumbers:
        for i, b in enumerate(boards):
            score = b.mark(drawn)
            if score:
                print(f"score of board {i+1}: {score}")
                return
    raise AssertionError('nobody won')

if __name__ == '__main__':
    main(sys.argv[1::])
