when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/long_double

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var v:seq[(f128, int)]
  for i in N:
    v.add (-f128(A[i]) / f128(A[i] + B[i]), i)
  echo v[0] < v[1]
  echo v[0] > v[1]
  #debug v
  #v.sort
  ## ソートできていない？
  #debug v
  #var ans:seq[int]
  #for i in N:
  #  ans.add v[i][1] + 1
  #echo ans.join(" ")
  #discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

