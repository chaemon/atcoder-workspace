const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/structure/universal_segtree

proc composition(a, b:int):int = a + b
proc id():int = 0

proc solve() =
  let N = nextInt()
  # 最小のところを探す
  v := Seq[tuple[y, t, xl, xr:int]]
  for _ in N:
    let M = nextInt()
    var
      p = Seq[tuple[x, y:int]]
      min_y = int.inf
    for i in M:
      let x, y = nextInt()
      p.add (x, y)
      min_y.min=y
    # yの最小の水平辺の方向をxの昇順に
    r := false
    for i in M:
      let i1 = (i + 1) mod M
      if p[i].y == min_y and p[i1].y == min_y:
        if p[i].x > p[i1].x: r = true
    if r: p.reverse
    for i in M:
      let i1 = (i + 1) mod M
      if p[i].y == p[i1].y:
        if p[i].x < p[i1].x:
          v.add (p[i].y, 1, p[i].x, p[i1].x)
        else:
          v.add (p[i].y, -1, p[i1].x, p[i].x)
  v.sort
  w := Seq[tuple[y, x, q: int]]
  let Q = nextInt()
  for q in Q:
    let x, y = nextInt()
    w.add (y, x, q)
  w.sort()
  ans := Seq[Q:int]
  #var st = initDualSegTree[int](10^5, composition, id)
  var st = initDualSegTree[int](10^5, (a, b:int) => a + b, () => 0)
  vi := 0
  for i in w.len:
    while vi < v.len and v[vi].y <= w[i].y:
      let (y, t, xl, xr) = v[vi]
      if t == 1:
        st.apply(xl ..< xr, 1)
      else:
        st.apply(xl ..< xr, -1)
      vi.inc
    let (y, x, q) = w[i]
    ans[q] = st[x]
  echo ans.join("\n")

when not defined(DO_TEST):
  solve()
else:
  discard
