const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import lib/structure/segtree_2d

let ∞ = int.inf

solveProc solve(H:int, W:int, N:int, r:seq[int], c:seq[int], a:seq[int]):
  var st = block:
    var v: seq[(int, int)]
    for i in N:
      v.add (r[i], c[i])
    initSegTree2D(v, (a, b:int) => max(a, b), () => -int.inf)
  var v: seq[tuple[a, r, c, i: int]]
  for i in N:
    v.add (a[i], r[i], c[i], i)
  v.sort(SortOrder.Descending)
  i := 0
  ans := Seq[N: int]
  while i < N:
    i2 := i
    while i2 < v.len and v[i].a == v[i2].a: i2.inc
    var next: seq[int]
    for j in i ..< i2:
      var u = 0
      u.max= st[v[j].r, -∞ .. ∞] + 1
      u.max= st[-∞ .. ∞, v[j].c] + 1
      ans[v[j].i] = u
      next.add u
    for j in i ..< i2:
      st[v[j].r, v[j].c] = next[j - i]
    i = i2
  echo ans.join("\n")
  return

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var r = newSeqWith(N, 0)
  var c = newSeqWith(N, 0)
  var a = newSeqWith(N, 0)
  for i in 0..<N:
    r[i] = nextInt()
    c[i] = nextInt()
    a[i] = nextInt()
  solve(H, W, N, r, c, a)
else:
  discard

