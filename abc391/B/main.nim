when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, S:seq[string], T:seq[string]):
  for a in N - M + 1:
    for b in N - M + 1:
      ok := true
      for i in M:
        for j in M:
          if S[a + i][b + j] != T[i][j]: ok = false
      if ok: echo a + 1, " ", b + 1;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  var T = newSeqWith(M, nextString())
  solve(N, M, S, T)
else:
  discard

