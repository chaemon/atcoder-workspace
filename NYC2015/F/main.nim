when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, a:seq[int], c:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var c = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    c[i] = nextInt()
  solve(N, a, c)
else:
  discard

