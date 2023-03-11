const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, A:seq[int]):
  var
    P = 0
    a = Seq[int]
  for i in N:
    a.add 0
    var a2 = Seq[int]
    for a in a.mitems:
      a += A[i]
      if a >= 4: P.inc
      else: a2.add a
    swap a, a2
  echo P
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

