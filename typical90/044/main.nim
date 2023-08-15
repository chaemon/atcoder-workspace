const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, Q:int, A:seq[int], T:seq[int], x:seq[int], y:seq[int]):
  Pred x, y
  var
    A = A
    s = 0
  for q in Q:
    if T[q] == 1:
      let
        x = (x[q] - s).floorMod N
        y = (y[q] - s).floorMod N
      swap A[x], A[y]
    elif T[q] == 2:
      s.inc
    elif T[q] == 3:
      let
        x = (x[q] - s).floorMod N
      echo A[x]
  return

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var T = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  for i in 0..<Q:
    T[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, Q, A, T, x, y)
