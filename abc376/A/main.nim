when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, C:int, T:seq[int]):
  var
    prev = -int.inf
    ans = 0
  for i in N:
    if T[i] - prev >= C:
      prev = T[i]
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var C = nextInt()
  var T = newSeqWith(N, nextInt())
  solve(N, C, T)
else:
  discard

