when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree

solveProc solve(N:int, X:seq[int], P:seq[int], Q:int, L:seq[int], R:seq[int]):
  var
    R = R
    v = X
  for i in Q:
    R[i].inc
    v.add L[i]
    v.add R[i]
  v.sort
  v = v.deduplicate(isSorted = true)
  var st = initSegTree[int](v.len, (a, b:int)=>a+b, ()=>0)
  for i in N:
    st[v.lowerBound(X[i])] = P[i]
  for i in Q:
    echo st.prod(v.lowerBound(L[i]) ..< v.lowerBound(R[i]))
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, nextInt())
  var P = newSeqWith(N, nextInt())
  var Q = nextInt()
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, X, P, Q, L, R)
else:
  discard

