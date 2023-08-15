when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:int, C:seq[int], D:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = nextInt()
  var C = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, H, C, D)
else:
  discard

