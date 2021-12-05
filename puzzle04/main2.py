from typing import Optional, List
from os import path
import sys
import re
from main1 import BingoBoard, getFilePathFromArgs


def main(args: List[str]):
    filePath = getFilePathFromArgs(args)
    boards: List[BingoBoard] = []
    with open(filePath, 'r') as file:
        lines = file.readlines()
        drawnNumbers = list(map(int, lines[0].split(',')))
        for i in range(0, len(lines)-2, 6):
            boards.append(BingoBoard(lines[2+i: 2+i+5]))
    
    for drawn in drawnNumbers:
        print(f"drew a {drawn}")
        for b in list(boards):# iterate a copy so that we can safly remove
            score = b.mark(drawn)
            if score and len(boards) > 1:
                print(f"{b} won on {drawn} with a score of {score} and is removed.")
                boards.remove(b)
                print(f"remaining boards {boards}")
            elif score:
                print(f"score of board {b}: {score}")
                return
                

if __name__ == '__main__':
    main(sys.argv[1::])
