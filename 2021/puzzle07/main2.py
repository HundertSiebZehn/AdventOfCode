from os import path
from typing import List, Tuple
from functools import cache
import sys
import timeit
from main1 import Flotilla

class FactorialFlotilla(Flotilla):
    @cache
    def _score(self, crab: int, target: int) -> int:
        return sum(range(abs(crab - target) + 1))

def getLinesFromFilePathFromArgs(args: List[str]) -> List[str]:
    if len(args) != 1:
        raise ValueError("input file not found.")
    inputFile = args[0]
    if not path.exists(inputFile):
        raise ValueError(f"'{inputFile}' was not found.")

    with open(inputFile, 'r') as file:
        return file.readlines()

def main(args: List[str]):
    start = timeit.default_timer()
    flot = FactorialFlotilla(
        list(map(int,getLinesFromFilePathFromArgs(args)[0].split(',')))
    )
    score, pos = flot.manuver()
    end = timeit.default_timer()
    print(f"lowest fuel consumtion at {pos}: {score} {(end-start) * 1000:.3f}ms")


if __name__ == '__main__':
    main(sys.argv[1::])
