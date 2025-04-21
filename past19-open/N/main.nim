when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import sugar

import atcoder/segtree

type S = tuple[s, p:float, n:int]

proc solve(N:int, A:seq[int], x:float, Q:int, l:seq[int], r:seq[int]) =
  Pred l
  proc op(l, r:S):S =
    if r.n == 0:
      return l
    else:
      return (l.s + r.s * l.p, l.p * r.p, l.n + r.n)
  var st = initSegTree[S](N, op, ()=>(0.0, 1.0, 0))
  for i in N:
    st[i] = (float(A[i]), x, 1)
  for i in Q:
    let (l, r) = (l[i], r[i])
    echo st[l ..< r].s
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var x = nextFloat()
  var Q = nextInt()
  var l = newSeqWith(Q, 0)
  var r = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt()
    r[i] = nextInt()
  solve(N, A, x, Q, l, r)
else:
  discard

