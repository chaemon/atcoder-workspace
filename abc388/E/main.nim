when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, A:seq[int]):
  proc calc(K:int):bool =
    if K * 2 > N: return false
    for i in 0 ..< K:
      if A[i] * 2 > A[N - K + i]: return false
    return true
  echo calc.maxRight(0 .. N)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

