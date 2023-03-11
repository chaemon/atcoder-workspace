const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/structure/universal_segtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, Q:int, L:seq[int], R:seq[int], X:seq[int]):
  proc composition(f, g:int):int = min(f, g)
  proc id():int = int.inf
  var st = initDualSegTree[int](N, composition, id)
  for i in Q:
    st.apply(L[i] ..< R[i], X[i])
  var
    XtoI = initTable[int, seq[int]]()
    XtoR = initTable[int, seq[(int, int)]]()
    ans = mint(1)
  for i in N:
    let u = st[i]
    if u == int.inf:
      ans *= M + 1
    else:
      XtoI[u].add i
  for i in Q:
    XtoR[X[i]].add (L[i], R[i])
  proc calc(X:int, R:seq[(int, int)], v:seq[int]):mint =
    type F = (bool, mint)
    proc op(a, b:mint):mint = a + b
    proc e():mint = mint(0)
    proc mapping(f:F, s:mint):mint =
      if f[0]: return 0
      else: return s * f[1]
    proc composition(f, g:F):F =
      if f[0] or g[0]: (true, mint(0))
      else: (false, f[1] * g[1])
    proc id():F = (false, mint(1))
    var
      R = R
      right = Seq[v.len: seq[int]]
    for (l, r) in R.mitems:
      (l, r) = (v.lowerBound(l), v.lowerBound(r))
      if l == r: return 0
      # l ..< r
      right[r - 1].add l
    var st = initLazySegTree[mint, F](v.len + 1, op, e, mapping, composition, id)
    st[0] = 1
    for i in 0 ..< v.len:
      # iをXにする: 直前はなんでもいい
      st[i + 1] = st[0 .. i]
      # iをXにしない: iで終わる区間の開始位置の一番右より前は0にする
      # 区間がないときは何もしないでいいのか?
      if right[i].len > 0:
        var left_start = -int.inf
        for l in right[i]: left_start.max= l
        st.apply(0 .. left_start, (true, mint(0)))
        st.apply(left_start + 1 ..< i + 1, (false, mint(X)))
      else:
        st.apply(0 ..< i + 1, (false, mint(X)))
    result = st.allProd()

  for X, R in XtoR:
    if X notin XtoI:
      ans = 0
    else:
      ans *= calc(X, R, XtoI[X])
  echo ans
  Naive:
    var
      ans = 0
      A = newSeq[int](N)
    proc check(A:seq[int]):bool =
      for i in Q:
        if A[L[i] ..< R[i]].max != X[i]: return false
      return true
    while true:
      if check(A): ans.inc
      i := 0
      while i < N:
        if A[i] == M:
          A[i] = 0
        else:
          A[i].inc
          break
        i.inc
      if i == N: break
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  var X = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt() - 1
    R[i] = nextInt()
    X[i] = nextInt()
  solve(N, M, Q, L, R, X)
else:
  import random
  for _ in 0 .. 100:
    var
      N = 5
      M = 5
      Q = 5
      L, R, X = newSeq[int](Q)
    for i in 0..<Q:
      L[i] = random.rand(0..<N)
      R[i] = random.rand(0..<N)
      if L[i] > R[i]: swap L[i], R[i]
      R[i].inc
      X[i] = random.rand(1..M)
    debug "test for", N, M, Q, L, R, X
    test(N, M, Q, L, R, X)

