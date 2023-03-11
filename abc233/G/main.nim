const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/cumulative_sum_2d


solveProc solve(N:int, S:seq[string]):
  var cs = initCumulativeSum2D[int](N, N)
  for i in N:
    for j in N:
      if S[i][j] == '#':
        cs.add(i, j, 1)
  cs.build()
  var dp = Seq[N, N + 1, N, N + 1: -1]
  proc calc(i0, i1, j0, j1:int):int =
    ret =& dp[i0][i1][j0][j1]
    if ret >= 0: return ret
    if cs[i0 ..< i1, j0 ..< j1] == 0:
      ret = 0
    else:
      ret = max(i1 - i0, j1 - j0)
      for i2 in i0 + 1 .. i1 - 1:
        ret.min= calc(i0, i2, j0, j1) + calc(i2, i1, j0, j1)
      for j2 in j0 + 1 .. j1 - 1:
        ret.min= calc(i0, i1, j0, j2) + calc(i0, i1, j2, j1)
    return ret
  echo calc(0, N, 0, N)
  discard

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
else:
  discard

