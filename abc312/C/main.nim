when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  proc f(X:int):bool =
    var buy, sell = 0
    for i in N:
      if A[i] <= X: sell.inc
    for i in M:
      if B[i] >= X: buy.inc
    return sell >= buy
  echo f.minLeft(0 .. 10^9 + 7)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
else:
  discard

