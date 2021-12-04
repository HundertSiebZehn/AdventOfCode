import sys;
from typing import List
from os import path

def main(args: List[str]):
    if len(args) != 1: 
        print("input file not found.")
        return
    inputFile = args[0]
    if not path.exists(inputFile): 
        print(f"'{inputFile}' was not found.")
        return
    
    numbers = readInput(inputFile)
    pairs = countIncreasingNeigbors(numbers)
    print(f"increased pairs: {pairs}")

def readInput(filePath: str)->List[int]:
    with open(filePath, 'r') as file:
        content = file.readlines()
        return list(map(lambda s: int(s), content))

def countIncreasingNeigbors(list: list[int])-> int:
    count = 0
    for (a, b) in zip(list[:-1:], list[1::]):
        if a < b:
            count += 1
    return count


if __name__ == '__main__': 
    main(sys.argv[1:])
