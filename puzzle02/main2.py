from typing import List, Literal, Tuple
from os import path
import sys
from main1 import getFilePathFromArgs, getInstructions, Submarine

class AimingSubmarine(Submarine):
    def __init__(self) -> None:
        super().__init__()
        self.aim = 0

    def move(self, cmd: Literal['forward', 'down', 'up'], delta):
        if cmd == 'forward':
            self.pos += delta
            self.depth += self.aim * delta
        elif cmd == 'down':
            self.aim += delta
        elif cmd == 'up':
            self.aim -= delta


def main(args: List[str]):
    file = getFilePathFromArgs(args)
    instructions = getInstructions(file)
    sub = AimingSubmarine()
    for cmd, delta in instructions:
        sub.move(cmd, delta)
    
    print(f"final position: {sub.pos}, depth: {sub.depth}")
    print(f"result: {sub.result()}")


if __name__ == '__main__':
    main(sys.argv[1::])
