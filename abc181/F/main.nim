include atcoder/extra/header/chaemon_header

import complex

import atcoder/dsu
import atcoder/extra/other/binary_search_float

proc solve(N:int, x:seq[int], y:seq[int]) =
  var p = newSeq[Complex[float]]()
  for i in 0..<N:
    p.add complex(x[i].float, y[i].float)
  proc test(r:float):bool =
    var dsu = initDSU(N + 2)
    for i in 0..<N:
      if abs(-100.0 - p[i].im) <= r * 2: dsu.merge(i, N)
      if abs(100.0 - p[i].im) <= r * 2: dsu.merge(i, N + 1)
      for j in i+1..<N:
        if abs(p[i] - p[j]) <= r * 2: dsu.merge(i, j)
    return dsu.leader(N) != dsu.leader(N + 1)
  echo findMax(test, 0.0..100.0, 1e-6)
  return

# input part {{{
block:
  var N = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, x, y)
#}}}
