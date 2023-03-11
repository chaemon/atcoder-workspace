const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import heapqueue

solveProc solve(N:int, L:int, A:seq[int]):
  ans := 0
  var q = initHeapQueue[int]()
  for i in N: q.push A[i]
  let d = L - A.sum
  if d > 0: q.push d
  while q.len > 1:
    var a, b = q.pop()
    ans += a + b
    q.push a + b
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, L, A)
else:
  discard

