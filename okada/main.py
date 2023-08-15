def solve(N, L, R, A):
    def get_cumsumlist(X:list):
        Xc = [0]
        for i in range(len(X)):
            Xc.append(Xc[-1] + X[i])   
        return Xc
     
    def get_diff_max_index(X, Y):
        diff = 0
        index = -1
        for i in range(len(X)):
            if diff < X[i] - Y[i]:
                diff = X[i] - Y[i]
                index = i
        return index
            

    # 累積和の計算
    Ac = get_cumsumlist(A)
    Bc = get_cumsumlist([L]*N)

    # 累積和の差が最大になるindexを取得
    j = get_diff_max_index(Ac, Bc)
    # ↑で求めた[0, index)までのAをLで塗りつぶす
    for i in range(j):
        A[i] = L

    # リストを反転
    A = A[::-1]
    # print(f'{A=}')
    Ac = get_cumsumlist(A)
    Bc = get_cumsumlist([R]*N)

    j = get_diff_max_index(Ac, Bc)

    for i in range(j):
        A[i] = R

    A = A[::-1]
    # print(f'{A=}')
    #print(sum(A))
    return sum(A)

def solve_naive(N, L, R, A):
    ans = 10**18
    for x in range(0, N + 1):
        for y in range(0, N + 1):
            A2 = A
            for i in range(x):
                A2[i] = L
            for j in range(y):
                A2[N - 1 - j] = R
            ans = min(ans, sum(A2))
    return ans

test = False

if not test:
    N, L, R = list(map(int, input().split()))
    A = list(map(int, input().split()))
    #for i in range(N):
    #    if A[i] != 0:
    #        print(i, A[i])

    print(solve(N, L, R, A))
else:
    import random
    N = 10
    M = 10
    for L in range(-M, M):
        for R in range(-M, M):
            A = [0 for i in range(N)]
            for i in range(N):
                A[i] = random.randint(-M, M)
                print(N, L, R, A)
                assert solve(N, L, R, A) == solve_naive(N, L, R, A)
    #N = 5
    #L = 4
    #R = 3
    #A = [5, 5, 0, 6, 3]
