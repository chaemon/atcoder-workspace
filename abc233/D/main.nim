const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
include atcoder/extra/forward_compatibility/hash_func

solveProc solve(N:int, K:int, A:seq[int]):
  a := initTable[int, int]()
  s := 0
  ans := 0
  a[s].inc
  for i in N:
    s += A[i]
    ans += a[s - K]
    a[s].inc
    discard
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

