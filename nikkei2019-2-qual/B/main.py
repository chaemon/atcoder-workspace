#!/usr/bin/env python3
import sys

MOD = 998244353  # type: int

def baai(n1, n2):
    return(n1**n2%MOD)

def solve(N: int, D: "List[int]"):
    cn=[0]*(N + 1)
    for i in range(N):
        cn[D[i]]+=1

    if D[0]!=0:
        print(0)
    else:
        answer=1
        bak=cn[0]
        kyo=1
        hen=1
        while True:
            cnt=cn[kyo]
            hen+=cnt
            if cnt==0:
                break
            answer=answer*baai(bak, cnt)%MOD
            bak=cnt
            kyo+=1
        if hen==N:
            print(answer%MOD)
        else:
            print(0)
    return


# Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
def main():
    def iterate_tokens():
        for line in sys.stdin:
            for word in line.split():
                yield word
    tokens = iterate_tokens()
    N = int(next(tokens))  # type: int
    D = [int(next(tokens)) for _ in range(N)]  # type: "List[int]"
    solve(N, D)

if __name__ == '__main__':
    main()
