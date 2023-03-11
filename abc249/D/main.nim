const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/eratosthenes

solveProc solve(N:int, A:seq[int]):
  var
    es = initEratosthenes()
    ct = Seq[2 * 10^5 + 1:0]
    ans = 0
  for i in A.len:
    ct[A[i]].inc
  for i in A.len:
    for d in es.divisor(A[i]):
      let e = A[i] div d
      ans += ct[d] * ct[e]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

