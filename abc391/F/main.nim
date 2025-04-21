when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import heapqueue

solveProc solve(N:int, K:int, A:seq[int], B:seq[int], C:seq[int]):
  shadow A, B, C
  A.sort(Descending)
  B.sort(Descending)
  C.sort(Descending)
  proc f(i, j, k:int):int = A[i] * B[j] + B[j] * C[k] + C[k] * A[i]
  var
    q = initHeapQueue[tuple[v, i, j, k:int]]()
    used = initSet[tuple[i, j, k:int]]()
  q.push (-f(0, 0, 0), 0, 0, 0)
  for ct in K:
    let (v, i, j, k) = q.pop()
    if ct == K - 1:
      echo -v;break
    if i + 1 < N and (i + 1, j, k) notin used:
      q.push (-f(i + 1, j, k), i + 1, j, k)
      used.incl (i + 1, j, k)
    if j + 1 < N and (i, j + 1, k) notin used:
      q.push (-f(i, j + 1, k), i, j + 1, k)
      used.incl (i, j + 1, k)
    if k + 1 < N and (i, j, k + 1) notin used:
      q.push (-f(i, j, k + 1), i, j, k + 1)
      used.incl (i, j, k + 1)
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var C = newSeqWith(N, nextInt())
  solve(N, K, A, B, C)
else:
  discard

