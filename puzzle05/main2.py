from main1 import getLineDefiniotns, getLinesFromFromArgsPath, VentMap
from typing import List, Tuple
import sys

class ExtendVentMap(VentMap):
    def markLine(self, line: Tuple[Tuple[int, int],Tuple[int, int]])->None:
        start, end = line
        x1, y1 = start
        x2, y2 = end
        if abs(x1 - x2) == abs(y1 - y2):
            #print(f"marking from ({x1}, {y1}) to ({x2}, {y2})")
            x_direction = 1 if x1 < x2 else -1
            y_direction = 1 if y1 < y2 else -1
            for x,y in zip(range(x1, x2 + x_direction, x_direction), range(y1, y2 + y_direction, y_direction)):
                self.mark(x,y)
        super().markLine(line)

def main(args: List[str]):
    lines = getLinesFromFromArgsPath(args)
    lines = getLineDefiniotns(lines)
    size = max(map(lambda line: max(line[0][0], line[0][1], line[1][0], line[1][1]), lines))
    vents = ExtendVentMap(size + 1)
    print(size)
    for line in lines:
        vents.markLine(line)
    
    print(f"at least {vents.score} points with overlapping lines")

if __name__ == '__main__':
    main(sys.argv[1::])
