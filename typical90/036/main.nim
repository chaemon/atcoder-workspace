const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, Q:int, x:seq[int], y:seq[int], q:seq[int]):
  # a = x + y, b = x - y
  var
    amin = int.inf
    bmin = int.inf
    amax = -int.inf
    bmax = -int.inf
  for i in N:
    let
      a = x[i] + y[i]
      b = x[i] - y[i]
    amin.min=a
    amax.max=a
    bmin.min=b
    bmax.max=b
  Pred q
  for i in q:
    let
      a = x[i] + y[i]
      b = x[i] - y[i]
    echo max(
      max(abs(a - amin), abs(a - amax)),
      max(abs(b - bmin), abs(b - bmax)))
  return

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  var q = newSeqWith(Q, nextInt())
  solve(N, Q, x, y, q)
