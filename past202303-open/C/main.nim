when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int]):
  var X = N @ int
  for K in 1 .. N:
    for i in N:
      if P[i] == K:
        X[K - 1] = i + 1
  echo X.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  discard

