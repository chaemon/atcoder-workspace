when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, M:int, A:seq[int]):
  if A.sum <= M:
    echo "infinite";return
  proc f(x:int):bool =
    s := 0
    for i in N:
      s += min(x, A[i])
    return s <= M
  echo f.maxRight(0 .. A.max)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

