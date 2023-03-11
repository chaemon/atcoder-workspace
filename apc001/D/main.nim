include atcoder/extra/header/chaemon_header

import atcoder/dsu

const NO = "Impossible"

proc solve(N:int, M:int, a:seq[int], x:seq[int], y:seq[int]) =
  var dsu = initDSU(N)
  for i in 0..<M:
    dsu.merge(x[i], y[i])
  let g = dsu.groups()
  var ans = 0
  var t = newSeq[int]()
  if g.len == 1:
    echo 0;return
  for v in g:
    var cs = v.mapIt(a[it])
    cs.sort()
    ans += cs[0]
    t &= cs[1..^1]
  t.sort()
  if t.len < g.len - 2:
    echo NO;return
  ans += t[0..<(g.len - 2)].sum
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(N-1-0+1, nextInt())
  var x = newSeqWith(M, 0)
  var y = newSeqWith(M, 0)
  for i in 0..<M:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, M, a, x, y)
#}}}
