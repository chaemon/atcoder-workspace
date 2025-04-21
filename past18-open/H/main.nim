when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/cumulative_sum_2d

solveProc solve():
  var
    N = nextInt()
    S = Seq[N: nextString()]
    cs = initCumulativeSum2D[int](N, N)
    ans = 0
  for i in N:
    for j in N:
      if S[i][j] == '#': cs.add(i, j, 1)
  cs.build()
  for i in N:
    for j in N:
      for l in 1 .. N:
        if i + l + 2 <= N and j + l + 2 <= N:
          if cs[i ..< i + l + 2, j ..< j + l + 2] == l + 2 + 2 * (l + 1) and cs[i + 1 ..< i + 1 + l, j + 1 ..< j + 1 + l + 1] == 0: ans.max=l
  echo ans

when not defined(DO_TEST):
  solve()
else:
  discard

