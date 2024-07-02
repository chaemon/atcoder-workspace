when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import heapqueue

type S = tuple[v, i:int]

solveProc solve(N:int, A:seq[int]):
  var
    d = Seq[N: 1]
    q = initHeapQueue[S]()
    ans = 0
  for i in N:
    q.push (((d[i] + 1)^2 - d[i]^2) * A[i], i)
    ans += d[i]^2 * A[i]
  for _ in N - 2:
    let (v, i) = q.pop()
    ans += v
    d[i].inc
    q.push (((d[i] + 1)^2 - d[i]^2) * A[i], i)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

