when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import heapqueue

solveProc solve(N:int, K:int, A:seq[int]):
  var
    q = initHeapQueue[int]()
    ct = 0
    p = -1
  q.push(0)
  while true:
    var u = q.pop
    if u == p:
      continue
    p = u
    if ct == K:
      echo u;return
    for i in N:
      q.push(u + A[i])
    ct.inc

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

