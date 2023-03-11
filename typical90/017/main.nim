const
  DO_CHECK = false
  DEBUG = true
include atcoder/extra/header/chaemon_header
import atcoder/segtree


solveProc solve(N:int, M:int, L:seq[int], R:seq[int]):
  # L[i] ..< R[i]
  var
    ans = 0
    st = initSegTree[int](N, (a, b:int) => a + b, ()=>0)
    v = Seq[tuple[L, R:int]]
  for i in M:
    v.add (L[i], R[i])
  v.sort()
  i := 0
  while i < M:
    i2 := i
    while i2 < M and v[i2].L == v[i].L: i2.inc
    for k in i ..< i2:
      let (L, R) = v[k]
      ans += st[L + 1 ..< R]
    for k in i ..< i2:
      let (L, R) = v[k]
      st[R] = st[R] + 1
    i = i2
  echo ans
  return

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt() - 1
    R[i] = nextInt() - 1
  solve(N, M, L, R)
