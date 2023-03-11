#!/usr/bin/env python3
import sys

def get(K: int, X: int, Y: int):
    p = None
    if X >= K:
        X -= K
        p = [K, 0]
    elif Y >= K:
        Y -= K
        p = [0, K]
    else:
        if X + Y >= K:
            p = [X, K - X]
            Y -= K - X
            X = 0
        else:
            p = [-K, 0]
            X += K
    return p, X, Y

def jump_two(K: int, X: int, Y: int):
    assert(X + Y < 2 * K)
    if X + Y == 0:
        return []
    elif X + Y == K:
        return [(X, Y)]
    ret = []
    rev = False
    if X > Y:
        X, Y = Y, X
        rev = True
    a = K - (Y - X)//2
    b = K - (Y + X)//2
    assert(0 <= a and a <= K)
    assert(0 <= b and b <= K)
    ret.append([a, K - a])
    ret.append([-b, K - b])
    if rev:
        for i in range(len(ret)):
            ret[i][0], ret[i][1] = ret[i][1], ret[i][0]
    return ret

def calc(K: int, X: int, Y: int):
    ret = []
    if X + Y < K:
        if (X + Y) % 2 != 0:
            # 3
            p, X, Y = get(K, X, Y)
            ret.append(p)
        ret += jump_two(K, X, Y)
        return ret
    while X + Y >= K * 2:
        p, X, Y = get(K, X, Y)
        ret.append(p)
    if X + Y == K:
        # 1
        ret.append([X, Y])
    else:
        # K * 2 > X + Y > K
        if (X + Y) % 2 != 0:
            p, X, Y = get(K, X, Y)
            ret.append(p)

        ret += jump_two(K, X, Y)
    return ret


def solve(K: int, X: int, Y: int):
    if K % 2 == 0 and (X + Y) % 2 != 0:
        print(-1)
        return
    negate_X = False
    negate_Y = False
    if X < 0:
        X *= -1
        negate_X = True
    if Y < 0:
        Y *= -1
        negate_Y = True
    v = calc(K, X, Y)
    for i in range(len(v)):
        if negate_X:
            v[i][0] *= -1
        if negate_Y:
            v[i][1] *= -1
    x = 0
    y = 0
    print(len(v))
    for dx, dy in v:
        x += dx
        y += dy
        print(x, y)
    return


# Generated by 1.1.6 https://github.com/kyuridenamida/atcoder-tools  (tips: You use the default template now. You can remove this line by using your custom template)
def main():
    def iterate_tokens():
        for line in sys.stdin:
            for word in line.split():
                yield word
    tokens = iterate_tokens()
    K = int(next(tokens))  # type: int
    X = int(next(tokens))  # type: int
    Y = int(next(tokens))  # type: int
    solve(K, X, Y)

if __name__ == '__main__':
    main()
