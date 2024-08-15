when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, L:seq[int], U:seq[int], Q:int, s_x:seq[int], s_y:seq[int], t_x:seq[int], t_y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = newSeqWith(N, 0)
  var U = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    U[i] = nextInt()
  var Q = nextInt()
  var s_x = newSeqWith(Q, 0)
  var s_y = newSeqWith(Q, 0)
  var t_x = newSeqWith(Q, 0)
  var t_y = newSeqWith(Q, 0)
  for i in 0..<Q:
    s_x[i] = nextInt()
    s_y[i] = nextInt()
    t_x[i] = nextInt()
    t_y[i] = nextInt()
  solve(N, L, U, Q, s_x, s_y, t_x, t_y)
else:
  discard

