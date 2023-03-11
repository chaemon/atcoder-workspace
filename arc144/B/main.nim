const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, a:int, b:int, A:seq[int]):
  proc f(M:int):bool =
    var m, p = 0
    for i in N:
      if A[i] <= M:
        m += (M - A[i]).ceilDiv a
      else:
        p += (A[i] - M).floorDiv b
    return p >= m
  echo f.maxRight(0 .. 10^9 + 1)
  discard

when not DO_TEST:
  var N = nextInt()
  var a = nextInt()
  var b = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, a, b, A)
else:
  discard

