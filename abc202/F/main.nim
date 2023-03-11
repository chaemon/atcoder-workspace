include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007


const DEBUG = true

type P = tuple[x, y:int]

proc `+`(a, b:P):P = (a.x + b.x, a.y + b.y)
proc `-`(a, b:P):P = (a.x - b.x, a.y - b.y)

proc cross(a, b:P):int = a.x * b.y - a.y * b.x

proc inner(a, b, c, p:P):bool =
  cross(b - a, p - a) * cross(c - a, p - a) < 0 and
  cross(c - b, p - b) * cross(a - b, p - b) < 0 and
  cross(a - c, p - c) * cross(b - c, p - c) < 0

proc solve(N:int, X:seq[int], Y:seq[int]):int =
  var (X, Y) = (X, Y)
  var PP = Seq[tuple[x, y:int]]
  for i in N: PP.add((X[i], Y[i]))
  PP.sort() do (a, b:P)->int:
    if a.x != b.x: return -cmp(a.x, b.x)
    elif a.y != b.y: return cmp(a.y, b.y)
    else: return 0
  for i in N: X[i] = PP[i].x; Y[i] = PP[i].y
#  debug PP
  var C = Seq[N, N, N: int]
  for i in 0..<N:
    for j in 0..<N:
      for k in 0..<N:
        for l in N:
          if i == l or j == l or k == l: continue
          if inner(PP[i], PP[j], PP[k], PP[l]): C[i][j][k].inc
  proc update(dps: var seq[seq[seq[mint]]], s:int, dp:seq[seq[seq[mint]]]) =
    for i in N:
      for j in N:
        for S in 0..1:
          dps[s][j][S] += dp[i][j][S]
  var dp0, dp1 = Seq[N, N, 2:mint]
  for s in 0..<N:
    var dp = Seq[N, N, 2: mint]
    for i in s + 1..<N: dp[s][i][0] = 1
    for i in s..<N: # now
      var dp2 = dp
      for j in s..<i:
        for k in s..<j:
          # (P[k], P[j]) -> (P[j], P[i])
          assert i > j and j > k
          let
            v0 = PP[j] - PP[k]
            v1 = PP[i] - PP[j]
          if cross(v0, v1) >= 0: continue
          let S = cross(PP[j] - PP[s], PP[i] - PP[s]).abs
          let d = mint(2)^C[s][i][j]
          for r in 0..1:
            let S2 = (r + S) mod 2
            dp2[j][i][S2] += dp[k][j][r] * d
      swap(dp, dp2)
    update(dp0, s, dp)
#  echo "dp0: "
#  for i in 0..<N:
#    for j in 0..<N:
#      for S in 0..1:
#        if dp0[i][j][S] != 0:
#          echo "area: ", i, " ", j, " ", S, " ", dp0[i][j][S]
  for s in 0..<N << 1:
    var dp = Seq[N, N, 2: mint]
    for i in 0..<s << 1: dp[s][i][0] = 1
    for i in 0..s << 1: # now
      var dp2 = dp
      for j in i+1..s << 1:
        for k in j+1..s << 1:
          # i < j < k
          # (P[k], P[j]) -> (P[j], P[i])
          let
            v0 = PP[j] - PP[k]
            v1 = PP[i] - PP[j]
          if cross(v0, v1) >= 0: continue
          let S = cross(PP[j] - PP[s], PP[i] - PP[s]).abs
          let d = mint(2)^C[s][i][j]
          for r in 0..1:
            let S2 = (r + S) mod 2
            assert i < j and j < k
            dp2[j][i][S2] += dp[k][j][r] * d
      swap(dp, dp2)
    update(dp1, s, dp)
#  for i in 0..<N:
#    for j in 0..<N:
#      for S in 0..1:
#        if dp1[j][i][S] != 0:
#          echo "area: ", i, " ", j, " ", S, " ", dp1[j][i][S]

  var ans = mint(0)
  for s in 0..<N:
    for t in s+1..<N:
      for r in 0..1:
        ans += dp0[s][t][r] * dp1[t][s][r]
      ans.dec
  return ans.val

const DO_TEST = false

when DO_TEST:
  import random
  randomize()

  import test
  proc solve_naive(N:int, X, Y:seq[int]):int =
    var PP = Seq[tuple[x, y:int]]
    for i in N: PP.add((X[i], Y[i]))
    return test(PP)

  proc collinear(p, q, r:P):bool =
    cross(p - r, q - r) == 0

  proc gen_ans(N:int):auto =
    const M = 1000
    var ans = Seq[P]
    while true:
      let p = (rand(0..M), rand(0..M))
      if p in ans: continue
      valid := true
      for i in 0..<ans.len:
        for j in i+1..<ans.len:
          if collinear(ans[i], ans[j], p): valid = false
      if not valid: continue
      ans.add(p)
      if ans.len == N: break
    var X, Y = Seq[int]
    for p in ans: X.add(p.x); Y.add(p.y)
    return (N, X, Y)
  for ct in 100:
    let (N, X, Y) = gen_ans(10)
    let
      ans_naive = solve_naive(N, X, Y)
      ans = solve(N, X, Y)
    debug ans, ans_naive
    debug N, X, Y, ans_naive, ans
    doAssert ans_naive == ans, "error!!"
  echo "test passed"
else:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  let ans = solve(N, X, Y)
  echo ans
#  let ans_naive = solve_naive(N, X, Y)
#  doAssert ans == ans_naive
