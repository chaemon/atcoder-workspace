when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import heapqueue

solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  var
    v:seq[tuple[A, B:int]]
    ans = int.inf
  for i in N:
    v.add (A[i], B[i])
  v.sort
  var
    q = initHeapQueue[int]() # Bの大きい順
    M = -int.inf
    s = 0
  for i in K:
    let (A, B) = v[i]
    q.push(-B)
    M.max=A
    s += B
  ans.min=M * s
  for i in K ..< N:
    let (A, B) = v[i]
    s -= -q.pop()
    q.push(-B)
    M.max=A
    s += B
    ans.min=M * s
  echo ans
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var K = nextInt()
    var A = newSeqWith(N, nextInt())
    var B = newSeqWith(N, nextInt())
    solve(N, K, A, B)
else:
  discard

