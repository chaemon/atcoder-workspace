when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/dsu

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], D:seq[int]):
  Pred A, B
  var
    v:seq[tuple[D, A, B:int]]
    st = initDSU(N)
  for i in M:
    v.add (D[i], A[i], B[i])
  v.sort(SortOrder.Descending)
  for (D, A, B) in v:
    st.merge(A, B)
    if st.size(0) == N:
      echo D;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var D = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    D[i] = nextInt()
  solve(N, M, A, B, D)
else:
  discard

