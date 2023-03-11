when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/longest_increasing_subsequence


solveProc solve(N:int, A:seq[int], B:seq[int]):
  var v = Seq[tuple[A, B:int]]
  for i in N:
    v.add (A[i], B[i])
  v.sort()
  var B2 = Seq[int]
  for i in N:
    B2.add v[i].B
  echo N + B2.longest_increasing_subsequence
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
else:
  discard

