when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils
import lib/other/binary_search

solveProc solve(N:int, K:int, X:seq[int], Y:seq[int], Z:seq[int]):
  var P = Seq[N: Array[3: int]]
  for i in N:
    P[i] = [X[i] * 2, Y[i] * 2, Z[i] * 2]
  proc f(c:int):tuple[v, n:int] =
    var dp = Seq[2^3: (v: -int.inf, n: -1)]
    dp[0] = (0, 0)
    for i in N:
      var dp2 = dp
      for b in 2^3:
        if dp[b].v == -int.inf: continue
        for j in 3:
          var
            b2 = b xor [j]
            v2 = dp[b].v + P[i][j] - c
            n2 = dp[b].n + (if b[j] == 1: 1 else: 0)
          dp2[b2].max=(v2, n2)
      dp = dp2.move
    return dp[0]
  proc fb(c:int):bool =
    # 上に凸
    # cを増加させるとiは減少
    # iで見るとfalse, false, ..., false, true, true, ..., trueとなるのでminLeftをとればよい
    if K < f(c).n: return false
    else: return true
  let
    c = fb.minLeft(0 .. 2^31)
    p = f(c)
  echo p.v div 2 + c * p.n

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var K = nextInt()
    var X = newSeqWith(N, 0)
    var Y = newSeqWith(N, 0)
    var Z = newSeqWith(N, 0)
    for i in 0..<N:
      X[i] = nextInt()
      Y[i] = nextInt()
      Z[i] = nextInt()
    solve(N, K, X, Y, Z)
else:
  discard

