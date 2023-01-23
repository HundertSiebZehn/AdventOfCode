
import sys
from typing import List, Tuple
from main1 import getLinesFromFilePathFromArgs


class School():
    MAX_AGE = 6
    NEW_GEN_AGE = 8

    def __init__(self, fishes: List[int]) -> None:
        self.dict = {}
        for f in fishes:
            if f in self.dict:
                self._incFishCount(f, 1)
            else:
                self.dict[f] = 1
        self.output(0)

    def tick(self, day: int) -> None:
        self.reset = 0
        def tock(fishAndCount:Tuple[int, int]) -> Tuple[int, int]:
            f, c = fishAndCount
            if f == 0:
                self.reset += c
                return (School.NEW_GEN_AGE, c)
            else:
                return (f - 1, c)
        self.dict = dict(map(tock, self.dict.items()))
        if self.reset:
            self._incFishCount(School.MAX_AGE, self.reset)

    def run(self, days: int) -> None:
        for day in range(days):
            self.tick(day + 1)
        self.output(days)

    def _incFishCount(self, fish: int, by: int) -> None:
        if not fish in self.dict:
            self.dict[fish] = by
        else:
            self.dict[fish] += by

    def output(self, day: int) -> None:
        print(f"Score day {day}: {self.score}")

    @property
    def score(self) -> int:
        return sum(self.dict.values())


def main(args: List[str]):
    fish = list(map(int, getLinesFromFilePathFromArgs(args)[0].split(',')))
    school = School(fish)
    school.run(256)


if __name__ == '__main__':
    main(sys.argv[1::])
