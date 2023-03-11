when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree

type P = tuple[s, m:int]

proc op(a, b:P):P = (a.s + b.s, min(a.m, b.m))
proc e():P = (0, int.inf)

solveProc solve(N:int, M:int, A:seq[int]):
  var st = initSegTree[P](N + 1, op, e)
  for i in N:
    if A[i] in 0 .. N:
      let p = st[A[i]].s + 1
      st[A[i]] = (p, p)
  var A = A
  for i in N:
    debug A
    if A[i] in 0 .. N:
      let p = st[A[i]].s - 1
      st[A[i]] = (p, p)
    A[i] += i + 1
    if A[i] in 0 .. N:
      let p = st[A[i]].s + 1
      st[A[i]] = (p, p)
    proc f(n:P):bool = n.m > 0
    echo st.maxRight(0, f) + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

