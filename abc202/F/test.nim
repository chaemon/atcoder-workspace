include atcoder/extra/header/chaemon_header

import atcoder/extra/geometry/geometry_template
import atcoder/extra/geometry/polygon
import atcoder/extra/other/bitutils

proc calc*(p:seq[(int, int)]):bool =
  var ans = 0
  var v = newSeq[Point[float]]()
  for p in p:
    v.add(initPoint(p[0].float, p[1].float))
  var u = v.convex_hull()
  if (u.area * 2).floor.int mod 2 == 0: return true
  else: return false

proc test*(p:seq[(int,int)]):int =
  let N = p.len
  for b in 0..<2^N:
    if b.popCount() < 3: continue
    var v = Seq[(int, int)]
    for i in 0..<N:
      if b[i]: v.add(p[i])
    if calc(v): result.inc
