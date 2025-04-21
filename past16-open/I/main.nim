when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import std/heapqueue

solveProc solve(N:int, M:int, K:int, A:seq[int]):
  var q = initHeapQueue[tuple[a, i:int]]()
  for i in N:
    q.push (A[i], i)
  while 
  var ans = Seq[N: int]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, K, A)
else:
  discard

