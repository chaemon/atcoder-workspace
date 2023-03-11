const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/convolution

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const B = 50

solveProc solve(H:int, W:int, S:seq[string], A:seq[int]):
  let p = 1 / mint(H * W)
  var P, Q, T = Seq[W + 1, 2 * B + 1: mint(0)]
  # P: (exp(px) + exp(-px))^i
  # Q: (exp(px) - exp(-px))^i
  P[0] = Seq[2 * B + 1: mint(0)]
  Q[0] = Seq[2 * B + 1: mint(0)]
  P[0][B] = 1
  Q[0][B] = 1
  for i in 1..W:
    for j in -B .. B:
      if j - 1 >= -B:
        P[i][j + B] += P[i - 1][j - 1 + B]
        Q[i][j + B] += Q[i - 1][j - 1 + B]
      if j + 1 <= B:
        P[i][j + B] += P[i - 1][j + 1 + B]
        Q[i][j + B] -= Q[i - 1][j + 1 + B]
  for i in 0..W:
    T[i] = P[W - i].convolution(Q[i])
    T[i] = T[i][B .. B * 3]


  proc calc2(a, A:int):seq[mint] = # aからAを作る
    # 0 ..< aに1がその他に0がある
    # 偶数回: f = exp(px) + exp(-px)をかける
    # 奇数回: g = exp(px) - exp(-px)をかける
    var dp = Seq[W + 1, W + 1: mint(0)] # index i, j: 値がiでgをj回かけたものの個数
    dp[a][0] = 1
    for t in W:
      var dp2 = dp
      if t < a:
        # 奇数回: 1 -> 0
        for i in 1 .. W:
          for j in 0 ..< W:
            dp2[i - 1][j + 1] += dp[i][j]
      else:
        # 奇数回: 0 -> 1
        for i in 0 ..< W:
          for j in 0 ..< W:
            dp2[i + 1][j + 1] += dp[i][j]
      swap dp, dp2
    result = Seq[B * 2 + 1: mint(0)]
    for i in dp[A].len: # 値がAでi回かける
      for j in -B..B:
        result[j + B] += dp[A][i] * T[i][j + B]

  proc calc(a:seq[int]):seq[mint] = # aからAを作る確率
    d := initDeque[seq[mint]]()
    for i in H:
      d.addFirst calc2(a[i], A[i])
    while d.len >= 2:
      d.addLast d.popFirst.convolution(d.popFirst)
    return d.popFirst
  
  var a = collect(newSeq):
      for i in H: S[i].count('1')
  
  F := calc(a)
  G := calc(A)
  proc calc_val1(F:seq[mint], mult:bool):mint = # multの場合は(1 - x)をかける
    result = mint(0)
    if not mult:
      for i in F.len:
        let d = i - H * B
        # F[i] / (1 - p * d * x)
        result += F[i] / (1 - p * d)
    else:
      found := false
      for i in F.len:
        let d = i - H * B
        if p * d == 1:
          found = true
          result += F[i]
          break
      doAssert found
    discard

  proc calc_diff1(F:seq[mint], mult:bool):mint =
    result = mint(0)
    if not mult:
      for i in F.len:
        let d = i - H * B
        result += F[i] * p * d / (1 - p * d)^2
    else:
      for i in F.len:
        let d = i - H * B
        if p * d == 1: continue
        result += - F[i] / (1 - p * d)
  let d = H * W + H * B
  var mult = false
  if d < G.len and G[d] != 0:
    mult = true
  var
    F0 = F.calc_val1(mult)
    G0 = G.calc_val1(mult)
    F1 = F.calc_diff1(mult)
    G1 = G.calc_diff1(mult)
  echo (G0 * F1 - F0 * G1) / G0^2
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  var A = newSeqWith(H, nextInt())
  solve(H, W, S, A)
else:
  discard

