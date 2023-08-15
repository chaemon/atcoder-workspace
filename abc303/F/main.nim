when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:int, t:seq[int], d:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = nextInt()
  var t = newSeqWith(N, 0)
  var d = newSeqWith(N, 0)
  for i in 0..<N:
    t[i] = nextInt()
    d[i] = nextInt()
  solve(N, H, t, d)
else:
  discard

