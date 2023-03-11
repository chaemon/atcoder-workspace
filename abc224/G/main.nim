const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, S:int, T:int, A:int, B:int):
  var X = sqrt((2 * N * B) / A)
  var E:float
  proc calc(t:float):float =
    return t * A / 2 + (N * B) / t - B - A / 2
  if X <= 1.0:
    E = calc(1.0)
  elif X >= T.float:
    E = calc(T.float)
  else:
    var t0 = (X + 1e-9).floor
    var t1 = t0 + 1.0
    E = min(calc(t0), calc(t1))
  if T < S:
    echo E + B
  else:
    var E0 = (T - S) * A
    echo min(E0, E + B)
  return

when not DO_TEST:
  var N = nextInt()
  var S = nextInt()
  var T = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(N, S, T, A, B)
else:
  discard

