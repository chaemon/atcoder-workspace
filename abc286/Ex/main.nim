when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include atcoder/extra/header/chaemon_header
import atcoder/extra/geometry/geometry_template
import atcoder/extra/geometry/polygon

import atcoder/extra/other/internal_complex

solveProc solve(N:int, x, y:seq[int], s, t:(int, int)):
  var p = Seq[Point[float]]
  for i in N:
    p.add initPoint[float](x[i], y[i])
  var
    s = initPoint[float](s[0], s[1])
    t = initPoint[float](t[0], t[1])
  p.add s
  p.add t
  v := p.convexHull()
  var si, ti = -1
  for i, a in v:
    if a =~ s: si = i
    if a =~ t: ti = i
  if si < 0 or ti < 0:
    echo abs(s - t);return
  var (x, y) = (si, ti)
  ans := float.inf
  for _ in 2:
    s := 0.0
    block:
      i := x
      while true:
        var i2 = i + 1
        if i2 == v.len: i2 = 0
        s += abs(v[i] - v[i2])
        i = i2
        if i == y: break
    ans.min=s
    swap x, y
  echo ans
  discard

when not defined(DO_TEST):
  let N = nextInt()
  var (x, y) = unzip(N, (nextInt(), nextInt()))
  var s, t = (nextInt(), nextInt())
  solve(N, x, y, s, t)
else:
  discard

