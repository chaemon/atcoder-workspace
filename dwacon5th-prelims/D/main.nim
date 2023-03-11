include atcoder/extra/header/chaemon_header
import atcoder/extra/dp/dual_cumulative_sum_2d

# dump {{{
import macros, strformat, terminal

macro dump*(n: varargs[untyped]): untyped =
#  var a = "stderr.write "
  var a = "stdout.write "
  for i,x in n:
    a = a & fmt""" "{x.repr} = ", {x.repr} """
    if i < n.len - 1:
      a.add(""", ", ",""")
  a.add(""","\n"""")
  parseStmt(a)
# }}}

import atcoder/extra/other/binary_search

proc addRect(cs:var DualCumulativeSum2D, p:(Slice[int], Slice[int]), d:int, D:int) =
  let (x, y) = p
  let
    xv = if x.a >= 0:
      @[x]
    elif x.b >= 0:
      @[x.a+D..<D, 0..x.b]
    else:
      @[x.a+D..x.b+D]
    yv = if y.a >= 0:
      @[y]
    elif y.b >= 0:
      @[y.a+D..<D, 0..y.b]
    else:
      @[y.a+D..y.b+D]
  for x in xv:
    for y in yv:
      cs.add((x, y), d)

proc solve(N:int, D:int, x:seq[int], y:seq[int]) =
  var a = Seq(D, D, 0)
  for i in 0..<N:
    a[x[i] mod D][y[i] mod D].inc
  var t = 0
  for i in 0..<D:
    t.max=a[i].max
  var k = 0
  while true:
    if t in k^2 + 1..(k + 1)^2:break
    k.inc
  var cs:DualCumulativeSum2D[int]
  proc test(r:int):bool =
    if r == 0: return false
    if r == D: return true
    cs.init(D, D)
    for x in 0..<D:
      for y in 0..<D:
        if a[x][y] > k * (k + 1):
          cs.add((0..<D, 0..<D), 1)
          cs.addRect((x-r+1..x, y-r+1..y), -1, D)
        elif a[x][y] > k * k:
          cs.addRect((x-D+1..x-r, y-D+1..y-r), 1, D)
    cs.build()
    for x in 0..<D:
      for y in 0..<D:
        if cs[(x, y)] == 0: return true
    return false
  let r = findMin(test, 0..D)
  echo r + k * D - 1
  return

# input part {{{
block:
  var N = nextInt()
  var D = nextInt()
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, D, x, y)
#}}}
