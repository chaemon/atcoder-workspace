when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:int, T:int, u:seq[int], v:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var T = nextInt()
  var u = newSeqWith(N-1, 0)
  var v = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, S, T, u, v)
else:
  discard

