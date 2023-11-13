when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, X:int, S:seq[int]):
  ans := 0
  for i in N:
    if S[i] <= X: ans += S[i]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var S = newSeqWith(N, nextInt())
  solve(N, X, S)
else:
  discard

