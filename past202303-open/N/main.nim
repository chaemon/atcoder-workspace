when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, C:int, D:int, d:seq[int], a:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var C = nextInt()
  var D = nextInt()
  var d = newSeqWith(N, 0)
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    d[i] = nextInt()
    a[i] = nextInt()
  solve(N, C, D, d, a)
else:
  discard

