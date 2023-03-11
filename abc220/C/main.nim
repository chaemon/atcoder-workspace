const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int], X:int):
  let S = A.sum
  let q = X div S
  var
    Y = q * S
    i = 0
  while true:
    Y += A[i]
    if X < Y:
      echo q * N + i + 1;return
    i.inc
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var X = nextInt()
  solve(N, A, X)
else:
  discard

