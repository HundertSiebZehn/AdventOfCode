from typing import List, Literal, Tuple
from os import path
import sys


def getFilePathFromArgs(args: List[str]) -> str:
    if len(args) != 1:
        raise ValueError("input file not found.")
    inputFile = args[0]
    if not path.exists(inputFile):
        raise ValueError(f"'{inputFile}' was not found.")

    return inputFile


def readFileInput(filePath: str) -> List[List[Literal[0, 1]]]:
    with open(filePath, 'r') as file:
        content = file.readlines()

        return list(map(lambda line: list(map(lambda number: int(number), line.strip())), content))


def main(args: List[str]):
    file = getFilePathFromArgs(args)
    binaries = readFileInput(file)
    transposedBinaries = zip(*binaries)
    columnSumAndLen = map(lambda column: (sum(column), len(column)), transposedBinaries)
    gammaAndEpsilonBin = zip(*map(lambda sumAndLen: (1 if sumAndLen[0] > (sumAndLen[1] / 2) else 0, 0 if sumAndLen[0] > (sumAndLen[1] / 2) else 1), columnSumAndLen))
    gammaAndEpisilon = list(map(lambda greekLetter: int(''.join(map(str, greekLetter)), 2), gammaAndEpsilonBin))
    
    result = gammaAndEpisilon[0] * gammaAndEpisilon[1]
    print(f"power consumption: {result}")




if __name__ == '__main__':
    main(sys.argv[1::])
