when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/lazysegtree
import sugar

proc mapping(f, s:int):int =
  if s == -int.inf: -int.inf
  else: f + s

proc composition(f1, f2:int):int =
  f1 + f2

solveProc solve(N:int, A:seq[int]):
  Pred A
  var
    st = initLazySegTree[int, int](N, (a, b:int) => max(a, b), () => -int.inf, mapping, composition, () => 0)
    dqs = Seq[N: initDeque[int]()]
    s = initSet[int]()
    ans = -int.inf
  for i in N: st[i] = 0
  for i in N:
    dqs[A[i]].addLast(i)
  for a in dqs.len:
    if dqs[a].len == 0: continue
    elif dqs[a].len == 1:
      st.apply(0 ..< N, 1)
    else:
      let (l, r) = (dqs[a][0], dqs[a][^1])
      # l + 1 .. rは2でその他1
      st.apply(0 ..< N, 1)
      st.apply(l + 1 .. r, 1)
  for i in N:
    if i in 1 .. N - 2:
      # 左は0 ..< iで切る
      # 次切る位置はi + 1 .. N - 1である
      ans.max=s.len + st.prod(i + 1 .. N - 1)
    # A[i]を除く
    let
      l0 = dqs[A[i]].popFirst()
    var l1:int
    if dqs[A[i]].len > 0:
      l1 = dqs[A[i]][0]
    else:
      l1 = N - 1
    s.incl A[i]
    # l0 + 1 .. l1の値が1減る
    st.apply(l0 + 1 .. l1, -1)
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

