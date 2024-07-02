when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, l:seq[int], r:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var l = newSeqWith(N, 0)
  var r = newSeqWith(N, 0)
  for i in 0..<N:
    l[i] = nextInt()
    r[i] = nextInt()
  solve(N, l, r)
else:
  discard

