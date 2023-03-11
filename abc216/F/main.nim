const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var (A, B) = (A, B)
  var v = Seq[(int, int)]
  for i in N:
    v.add((A[i], B[i]))
  v.sort()
  for i in N:
    A[i] = v[i][0]
    B[i] = v[i][1]
  const T = 5010
  var dp = Array[T: mint(0)]
  dp[0] = 1
  var ans = mint(0)
  for i in 0..<N:
    for s in 0..<dp.len:
      if s + B[i] <= A[i]:
        ans += dp[s]
    var dp2 = dp
    for s in 0..<dp.len:
      if s + B[i] < T:
        dp2[s + B[i]] += dp[s]
    swap dp, dp2
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)

