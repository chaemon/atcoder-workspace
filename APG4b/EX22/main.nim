when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, a:seq[int], b:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, a, b)
else:
  discard

