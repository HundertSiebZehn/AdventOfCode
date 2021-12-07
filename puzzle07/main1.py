from os import path
from typing import List, Literal, Tuple, Type, TypeVar
import sys
import timeit

class Flotilla():
    def __init__(self, crabs: List[int]) -> None:
        self.crabs = crabs

    def manuver(self)->Tuple[int, int]:
        mini, maxi = min(self.crabs), max(self.crabs)
        lowest = sys.maxsize
        pos = None
        
        for target in range(mini, maxi + 1):
            current = sum(map(lambda c: self._score(c, target), self.crabs))
            if current < lowest:
                lowest = current
                pos = target
            #print(f"{target:2}: ({current:3}){'*' * current}")
        return lowest, pos

    def _score(self, crab: int, target: int) -> int:
        return abs(crab - target)

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
    flot = Flotilla(
        list(map(int,getLinesFromFilePathFromArgs(args)[0].split(',')))
    )
    score, pos = flot.manuver()
    end = timeit.default_timer()
    print(f"lowest fuel consumtion at {pos}: {score} {(end-start) * 1000:.3f}ms")


if __name__ == '__main__':
    main(sys.argv[1::])
