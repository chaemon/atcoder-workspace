when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(P:seq[seq[int]]):
  var ans = Seq[18: 0.0]
  for i in 6:
    for j in 6:
      for k in 6:
        let S = i + j + k + 3
        ans[S - 1] += (P[0][i] * P[1][j] * P[2][k]) / 1000000
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var P = newSeqWith(3, newSeqWith(6, nextInt()))
  solve(P)
else:
  discard

