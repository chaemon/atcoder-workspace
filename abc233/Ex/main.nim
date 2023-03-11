const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree

import random
const B = 10^5 + 5

# (x, y) -> (x + y, x - y + B)

solveProc solve(N:int, x:seq[int], y:seq[int], Q:int, a:seq[int], b:seq[int], K:seq[int]):
  var
    p = newSeqWith(Q, (l: 0, r:B * 3)) # l: < K r: >= K
    P = Seq[tuple[x, y:int]]
  for i in N:
    P.add((x[i] + y[i], x[i] - y[i] + B))
  block:
    T := initSet[(int, int)]()
    for i in N: T.incl((x[i] + y[i], x[i] - y[i] + B))
    for q in Q:
      if (a[q] + b[q], a[q] - b[q] + B) in T and K[q] == 1:
        p[q] = (-1, 0)
  var st = initSegTree[int](B * 2, (a, b:int)=>a+b, ()=>0)
  P.sort
  var lct = 0
  while true:
    lct.inc
    found := false
    P2 := Seq[tuple[x, t, ly, ry, q:int]]
    var update = Seq[Q:true]
    for q in Q:
      if p[q].l + 1 == p[q].r:
        update[q] = false
        continue
      found = true
      let mid = (p[q].l + p[q].r) div 2
      let
        a1 = a[q] + b[q]
        b1 = a[q] - b[q] + B
      var
        lx = max(a1 - mid, 0)
        ly = max(b1 - mid, 0)
        rx = min(a1 + mid + 1, B * 2)
        ry = min(b1 + mid + 1, B * 2)
      P2.add((lx, -1, ly, ry, q))
      P2.add((rx, 1, ly, ry, q))
    if not found:
      break
    P2.sort
    ct := Seq[Q:0]
    st = initSegTree[int](B * 2, (a, b:int)=>a+b, ()=>0)
    var
      Pi = 0
      P2i = 0
    for x in 0 .. B * 2:
      while P2i < P2.len and P2[P2i].x == x:
        let (x, t, ly, ry, q) = P2[P2i]
        ct[q] += st[ly ..< ry] * t
        P2i.inc
      while Pi < P.len and P[Pi].x == x:
        st[P[Pi].y] = st[P[Pi].y] + 1
        Pi.inc
    for q in Q:
      if not update[q]: continue
      let mid = (p[q].l + p[q].r) div 2
      if ct[q] < K[q]:
        p[q] = (mid, p[q].r)
      else:
        p[q] = (p[q].l, mid)
  for q in Q:
    echo p[q].r
  Naive:
    for i in Q:
      var d = Seq[int]
      for j in N:
        d.add abs(x[j] - a[i]) + abs(y[j] - b[i])
      d.sort
      echo d[K[i] - 1]
  discard

when not DO_TEST:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  var Q = nextInt()
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  var K = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    b[i] = nextInt()
    K[i] = nextInt()
  solve(N, x, y, Q, a, b, K)
else:
  for _ in 100:
    let
      N = 10
      Q = 10
    p := initSet[(int, int)]()
    x := Seq[int]
    y := Seq[int]
    while x.len < N:
      let
        a = random.rand(0..10)
        b = random.rand(0..10)
      if (a, b) in p: continue
      x.add a
      y.add b
    a := Seq[int]
    b := Seq[int]
    K := Seq[int]
    for _ in Q:
      a.add random.rand(0..10)
      b.add random.rand(0..10)
      K.add random.rand(1..N)
    debug N, x, y, Q, a, b, K
    test(N, x, y, Q, a, b, K)

  discard

