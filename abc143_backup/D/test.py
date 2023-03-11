#!/usr/bin/env python3
import sys

def solve(N: int, L: "List[int]"):
    L.sort()
    sum = 0

    for i in range(N-2):
        k = 0
        for j in range(i+1,N-1):
            tansum = L[i] + L[j]
            while k < len(L) and L[k] < tansum: k += 1
            if tansum <= L[j+1]:
                continue
#            sum=sum+bi.bisect_left(L[j+1:N+1],tansum)
            sum = sum + k - j - 1
    print(sum)
    return


def main():
    def iterate_tokens():
        for line in sys.stdin:
            for word in line.split():
                yield word
    tokens = iterate_tokens()
    N = int(next(tokens))  # type: int
    L = [int(next(tokens)) for _ in range(N)]  # type: "List[int]"
    solve(N, L)

if __name__ == '__main__':
    main()

