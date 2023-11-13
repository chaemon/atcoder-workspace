when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(L:seq[int], R:seq[int]):
  discard

when not defined(DO_TEST):
  var L = newSeqWith(3, 0)
  var R = newSeqWith(3, 0)
  for i in 0..<3:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(L, R)
else:
  discard

