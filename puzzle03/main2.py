from typing import ForwardRef, List, Literal, Tuple, Callable
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

def filterBinarys(binaries: List[List[Literal[0, 1]]], ratingFunc: Callable[[List[int]], Literal[0, 1]], colIndex: int = 0)->List[Literal[0, 1]]:
    columns = list(zip(*binaries))
    rating = ratingFunc(columns[colIndex])
    #print(f"rating column {colIndex} of\n\t{repr(binaries)}\n{columns[colIndex]}: {rating}")


    filtered = list(filter(lambda bin: bin[colIndex] == rating, binaries))
    if len(filtered) == 1:
        #print(f"relevant element found: {filtered[0]}")
        return filtered[0]
    elif len(filtered) == 0:
        raise ValueError('filtered too much')
    else:
        return filterBinarys(filtered, ratingFunc, colIndex + 1)

def toDec(bin: List[Literal[0, 1]])->int:
    return int(''.join(map(str, bin)), 2)


def main(args: List[str]):
    file = getFilePathFromArgs(args)
    binaries = readFileInput(file)
    oxyginRating = toDec(filterBinarys(binaries, lambda column: 1 if sum(column) >= (len(column) / 2) else 0))
    scrubberRating = toDec(filterBinarys(binaries, lambda column: 0 if sum(column) >= (len(column) / 2) else 1))

    result = oxyginRating * scrubberRating

    print(f"life support rating: {result}")




if __name__ == '__main__':
    main(sys.argv[1::])
