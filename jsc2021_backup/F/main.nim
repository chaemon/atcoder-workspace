include atcoder/extra/header/chaemon_header

import atcoder/segtree

const DEBUG = true

let N, M, Q = nextInt()
let (T, X, Y) = unzip(Q, (nextInt(), nextInt() - 1, nextInt()))

var v = @[0]
for i in 0..<Q: v.add(Y[i])
v = v.toSet().toSeq().sorted()

type P = tuple[n, s:int]
op(a, b:P) => (a.n + b.n, a.s + b.s)
e() => (0, 0)
var sta, stb = initSegTree(v.len, op, e)

var a = 0.repeat(N)
var b = 0.repeat(M)


sta[0] = (N, 0)
stb[0] = (M, 0)

var s = 0

for i in 0..<Q:
  if T[i] == 1:
    let s_old = block:
      var y = v.binarySearch(a[X[i]])
      var p = stb[y..^1]
      var q = sta[y]
      q.n.dec
      q.s -= a[X[i]]
      sta[y] = q
      p.s + (M - p.n) * a[X[i]]
    a[X[i]] = Y[i]
    let s_new = block:
      var y = v.binarySearch(a[X[i]])
      var p = stb[y..^1]
      var q = sta[y]
      q.n.inc
      q.s += a[X[i]]
      sta[y] = q
      p.s + (M - p.n) * a[X[i]]
    s = s - s_old + s_new
  else:
    let s_old = block:
      var y = v.binarySearch(b[X[i]])
      var p = sta[y..^1]
      var q = stb[y]
      q.n.dec
      q.s -= b[X[i]]
      stb[y] = q
      p.s + (N - p.n) * b[X[i]]
    b[X[i]] = Y[i]
    let s_new = block:
      var y = v.binarySearch(b[X[i]])
      var p = sta[y..^1]
      var q = stb[y]
      q.n.inc
      q.s += b[X[i]]
      stb[y] = q
      p.s + (N - p.n) * b[X[i]]
    s = s - s_old + s_new
  echo s

