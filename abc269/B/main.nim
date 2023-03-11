when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(S:seq[string]):
  var A, C = int.inf
  var B, D = -int.inf
  for i in S.len:
    for j in S[0].len:
      if S[i][j] == '#':
        A.min= i + 1
        C.min= j + 1
        B.max= i + 1
        D.max= j + 1
  echo A, " ", B
  echo C, " ", D
  discard

when not defined(DO_TEST):
  var S = newSeqWith(10, nextString())
  solve(S)
else:
  discard

