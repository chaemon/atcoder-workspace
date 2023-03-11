const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import std/complex

const EPS = 1e-9

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, a, b, c, d:seq[int]):
  if N == 1: echo YES;return
  var p, q = newSeq[Complex[float]]()
  for i in N: p.add(complex(a[i].float, b[i].float))
  for i in N: q.add(complex(c[i].float, d[i].float))
  let s = block:
    var s = initSet[(int, int)]()
    for i in N: s.incl((c[i], d[i]))
    s
  for i in 0..<N:
    for j in 0..<N:
      if i == j: continue
      if abs(p[0] - p[1]) !=~ abs(q[i] - q[j]): continue
      let z = (q[j] - q[i]) / (p[1] - p[0])
      var ok = true
      for k in N:
        let t = (p[k] - p[0]) * z + q[i]
        var x = (t.re + EPS).floor.int
        if t.re - x.float !=~ 0: ok = false
        var y = (t.im + EPS).floor.int
        if t.im - y.float !=~ 0: ok = false
        if (x, y) notin s: ok = false
      if ok:
        echo YES;return
  echo NO
  discard


let N = nextint()

var (a, b) = unzip(N, (nextInt(), nextInt()))
var (c, d) = unzip(N, (nextInt(), nextInt()))

solve(N, a, b, c, d)
