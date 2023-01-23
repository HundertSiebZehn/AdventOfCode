import sys
from os import path
from typing import List

class School():
    MAX_AGE = 6
    NEW_GEN_AGE = 8
    def __init__(self, fishes: List[int]) -> None:
        self.fish: List[int]= fishes
        self.output(0)
    
    def tick(self)->None:
        new_fish = []
        def tock(n: int)->int:
            if n == 0:
                new_fish.append(School.NEW_GEN_AGE)
                return School.MAX_AGE
            else:
                return n - 1
        self.fish = list(map(tock, self.fish))
        self.fish.extend(new_fish)

    def run(self, days: int)->None:
        for day in range(days):
            self.tick()
        self.output(days)

    def output(self, day: int)->None:
        print(f"Score day {day}: {self.score}")

    @property
    def score(self)->int:
        return len(self.fish)


def getLinesFromFilePathFromArgs(args: List[str]) -> List[str]:
    if len(args) != 1:
        raise ValueError("input file not found.")
    inputFile = args[0]
    if not path.exists(inputFile):
        raise ValueError(f"'{inputFile}' was not found.")

    with open(inputFile, 'r') as file:
        return file.readlines()

def main(args: List[str]):
    fish = list(map(int, getLinesFromFilePathFromArgs(args)[0].split(',')))
    school = School(fish)
    school.run(80)


if __name__ == '__main__':
    main(sys.argv[1::])
