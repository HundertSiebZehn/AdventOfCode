from typing import List
from main1 import countIncreasingNeigbors, getFilePathFromArgs, readFileInput
import sys

def main(args: List[str]):
    file = getFilePathFromArgs(args)
    numbers = readFileInput(file)

    sums = list(map(sum, zip(numbers, numbers[1::], numbers[2::])))

    count = countIncreasingNeigbors(sums)

    print(f"increased 3-sums: {count}")

if __name__ == '__main__':
    main(sys.argv[1::])