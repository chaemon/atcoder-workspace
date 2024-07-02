when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  Pred A, B
  var d = initDSU(N)
  for i in M:
    d.merge(A[i], B[i])
  var ans = 0
  for g in d.groups:
    ans += (g.len * (g.len - 1)) div 2
  ans -= M
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

