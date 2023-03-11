include atcoder/extra/header/chaemon_header

proc solve() =
  proc calc_min(v:seq[(int,int)]):int =
    var m = -int.inf
    for p in v:
      m.max=p[0]
    return m
  proc check(v:seq[(int,int)]) =
    var a, b, c, d:int
    for p in v:
      assert p[0] in 0..10^9
      assert p[1] in 0..10^9
    block:
      var s = initSet[int]()
      for p in v: s.incl(p[1])
      a = s.len
    block:
      var s = initSet[int]()
      for p in v: s.incl(p[0] - p[1])
      b = s.len
    block:
      var s = initSet[int]()
      for p in v: s.incl(p[0])
      c = s.len
    block:
      var s = initSet[int]()
      for p in v: s.incl(p[0] + p[1])
      d = s.len
#    echo a, " ", b, " ", c, " ", d
    assert d >= 10 * min([a, b, c])
  var v = @[(0, 0), (1, 0), (0, 1)]
  for i in 0..<6:
#  for i in 0..<1:
    var v2 = v
    let m = calc_min(v)
    for p in v: v2.add((p[0] + 2 * m + 1, p[1]))
    for p in v: v2.add((p[0], p[1] + 2 * m + 1))
    swap(v, v2)
  for p in v.mitems:
    p[0] = 10^9 - p[0]
  echo v.len
  for p in v:
    echo p[0], " ", p[1]
  v.check()
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
