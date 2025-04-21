when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/lazysegtree

solveProc solve(N:int, A:seq[int], B:seq[int], Q:int, t:seq[int]):
  var v:seq[int]
  for i in N:
    v.add A[i]
    v.add B[i] + 1
  v.add t
  v.sort
  v = v.deduplicate(isSorted = true)
  var st = initLazySegTree[int, int](v.len, (a, b:int)=>a+b, ()=>0, (a, b:int)=>a+b, (a, b:int)=>a+b, ()=>0)
  for i in N:
    st.apply(v.lowerBound(A[i]) ..< v.lowerBound(B[i] + 1), 1)
  for i in Q:
    echo st[v.lowerBound(t[i])]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  var Q = nextInt()
  var t = newSeqWith(Q, nextInt())
  solve(N, A, B, Q, t)
else:
  discard

