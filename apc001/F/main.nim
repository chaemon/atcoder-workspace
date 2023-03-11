include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/other/bitutils

const DEBUG = true

proc solve(N:int, x:seq[int], y:seq[int], a:seq[int]) =
  g := initGraph[int](N)
  for i in 0..<N - 1:
    g.addBiEdge(x[i], y[i], a[i])
  ans := 0
  a := Array(16, int)
  for u in 0..<N:
    s := 0
    for e in g[u]:
      s = s xor e.weight
    a[s].inc
  var v = newSeq[int]()
  for i in 1..<16:
    ans += a[i] div 2
    if a[i] mod 2 == 1: v.add(i)
  ans += v.len
  var ct = 0
  while v.len > 0:
    for b in 1..<2^v.len:
      s := 0
      for i in v.len:
        if b[i]:
          s.xor= v[i]
      if s == 0:
        ct.inc
        v2 := newSeq[int]()
        for i in v.len:
          if not b[i]:
            v2.add(v[i])
        swap(v, v2)
        break
  ans -= ct
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var x = newSeqWith(N-1, 0)
  var y = newSeqWith(N-1, 0)
  var a = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    x[i] = nextInt()
    y[i] = nextInt()
    a[i] = nextInt()
  solve(N, x, y, a)
#}}}

