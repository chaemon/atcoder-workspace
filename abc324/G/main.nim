when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/structure/segtree_2d, lib/other/binary_search

solveProc solve(N:int, A:seq[int], Q:int, t:seq[int], s:seq[int], x:seq[int]):
  var v = collect(newSeq):
    for i in N:
      (x:i, y:A[i])
  var st = initSegTree2D(v, (x, y:int)=>x+y, ()=>0)
  for i in N:
    st.add(i, A[i], 1)
  var q:seq[tuple[l, r, m, M:int]] = @[(0, N, 0, N + 1)] # l ..< rのインデックスのm ..< Mの値を考える
  for i in Q:
    var (l, r, m, M) = q[s[i]]
    doAssert l <= r and m <= M
    if t[i] == 1:
      # インデックスx[i]より後を除く。
      # 前半はx[i]個
      let n = st.prod(l ..< r, m ..< M)
      if n <= x[i]:
        q.add (l, r, m, m)
      else:
        proc f(t:int):bool = st.prod(l ..< t, m ..< M) >= x[i]
        let t = min(f.minLeft(l .. r), r)
        q.add (t, r, m, M)
        q[s[i]] = (l, t, m, M)
    elif t[i] == 2:
      let X = min(x[i] + 1, M)
      if X <= m:
        q[s[i]] = (l, r, m, m)
        q.add (l, r, m, M)
      elif X <= M:
        q.add (l, r, X, M)
        q[s[i]] = (l, r, m, X)
      else:
        q.add (l, r, M, M)
    else:
      doAssert false
    block:
      let (l, r, m, M) = q[i + 1]
      ans := st.prod(l ..< r, m ..< M)
      echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var s = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    s[i] = nextInt()
    x[i] = nextInt()
  solve(N, A, Q, t, s, x)
else:
  discard

