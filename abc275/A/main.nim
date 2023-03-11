when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, H:seq[int]):
  var
    mi = -1
    m = -int.inf
  for i in N:
    if H[i] > m:
      m = H[i]
      mi = i
  echo mi + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = newSeqWith(N, nextInt())
  solve(N, H)
else:
  discard

