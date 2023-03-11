const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const B = 3000
var next = Array[B + 1, 1..B: int]
var dp = Array[B + 1, 1..B: mint(0)]

solveProc solve(N:int, A:seq[int]):
  for d in 1..B:
    var s = 0
    var rem = Seq[d: -1]
    rem[0] = N
    for i in countdown(N - 1, 0):
      s += A[i]
      s.mod= d
      next[i][d] = rem[s]
      rem[s] = i
  dp[1][1] = 1
  for i in 1..<N:
    for d in 1..B:
      if dp[i][d] == 0: continue
      for d2 in [d, d + 1]:
        let j = next[i][d2]
        if j == -1: continue
        dp[j][d2] += dp[i][d]
  echo dp[N].sum
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A, true)
#}}}

