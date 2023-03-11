const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve():
  const SZ = 20
  let N, M, Q = nextInt()
  var (A, B, S, T) = unzip(M, (nextInt() - 1, nextInt() - 1, nextInt(), nextInt()))
  var bus = Seq[N: seq[tuple[t, i:int]]]
  for i in M:
    bus[A[i]].add (S[i], i)
  for u in N: bus[u].sort
  var next = Seq[M: array[SZ, int]]
  # next[b][i]はバスbの次の2^i番目のバス
  # 存在しないなら-1
  for b in M:
    # バスbはA[b]とB[b]を時刻S[b] + 1/2から時刻T[b] + 1/2へ
    var lb = bus[B[b]].lowerBound((T[b], -1))
    if lb == bus[B[b]].len: next[b][0] = -1
    else: next[b][0] = bus[B[b]][lb].i
  # nextを伝搬
  for b in M:
    for c in SZ - 1:
      if next[b][c] == -1: next[b][c + 1] = -1
      else: next[b][c + 1] = next[next[b][c]][c]
  proc calc(b, t:int):tuple[t, i: int] =
    # バスbから時刻tの先
    # 正確にはA[b]に時刻S[b]にいるとき時刻S[b] + tでどこにいるか？
    # t = 0なら都市, t = 1ならバス
    # iは都市やバスのインデックス
    let d = S[b] + t
    doAssert t >= 0
    if t == 0: return (0, A[b])
    elif t <= T[b] - S[b]: return (1, b)
    elif next[b][0] == -1 or d <= S[next[b][0]]:
      return (0, B[b])
    else:
      # next[b][c] != -1となるインデックスを探す
      var c = SZ - 1
      while next[b][c] == -1:
        c.dec
      while c >= 0:
        let i = next[b][c]
        # A[i] -> B[i]を時刻S[i] + 1/2からT[i] + 1/2で
        if S[i] <= d:
          # S[i]まで進めてよい
          return calc(i, d - S[i])
        c.dec
      doAssert false
  for _ in Q:
    let X = nextInt()
    let Y = nextInt() - 1
    let Z = nextInt()
    var lb = bus[Y].lowerBound((X, -1))
    if lb == bus[Y].len:
      echo Y + 1
    else:
      let sb = bus[Y][lb].i # 最初のバス
      if Z <= S[sb]:
        echo Y + 1
      else:
        let d = Z - S[sb]
        let (t, i) = calc(sb, d)
        if t == 0:
          echo i + 1
        else:
          echo A[i] + 1, " ", B[i] + 1

when not defined(DO_TEST):
  solve()
