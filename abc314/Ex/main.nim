when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/geometry/geometry_template
import atcoder/extra/other/internal_complex
#import std/complex

#let gr = (sqrt(5.0) + 1.0) / 2.0
#
#proc goldenSectionSearch(f:proc(x:float):float, a, b:float, tol=1e-9):tuple[x, v:float] =
#  var
#    (a, b) = (a, b)
#    c = b - (b - a) / gr
#    d = a + (b - a) / gr
#  while abs(b - a) > tol:
#    if f(c) < f(d):
#      b = d
#    else:
#      a = c
#
#    c = b - (b - a) / gr
#    d = a + (b - a) / gr
#  let x = (b + a) / 2.0
#  return (x, f(x))

proc goldenSectionSearch(f:proc(x:float):float, a, b:float, tol=1e-12):tuple[x, v:float] =
  const
    invphi = (sqrt(5.0) - 1.0) / 2.0 # 1 / phi
    invphi2 = (3.0 - sqrt(5.0)) / 2.0 # 1 / phi^2
  var
    (a, b) = (min(a, b), max(a, b))
    h = b - a
    c = a + invphi2 * h
    d = invphi * h
    yc = f(c)
    yd = f(d)
  for _ in 0 .. 300:
  #while b - a > tol:
    if yc < yd:
      b = d
      d = c
      yd = yc
      h = invphi * h
      c = a + invphi2 * h
      yc = f(c)
    else:
      a = c
      c = d
      yc = yd
      h = invphi * h
      d = a + invphi * h
      yd = f(d)

  let x = (b + a) / 2.0
  return (x, f(x))

solveProc solve(N:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int]):
  var
    p, q:seq[Point[float]]
    l: seq[Line[float]]
  for i in N:
    p.add initPoint[float](a[i], b[i])
    q.add initPoint[float](c[i], d[i])
    l.add p[i] -- q[i]
  proc f(x, y:float):float = # (x, y)を中心としたときの半径rの最小値
    result = -float.inf
    var c = initPoint(x, y)
    for i in N:
      # cからP[i], q[i]を結ぶ線分に垂線の足を求める
      let t = projection(c, l[i])
      #debug dot(p[i] - q[i], t - c)
      #doassert abs(dot(p[i] - q[i], t - c)) < 1e-9
      # ccwがうまくいってない？
      #let x = ccw(p[i], q[i], t)
      #if x == ON_SEGMENT:
      #  result.max= norm(t - c)
      #else:
      #  result.max=min(norm(p[i] - c), norm(q[i] - c))
      let
        u = dot(t - p[i], q[i] - p[i])
        d = norm(q[i] - p[i])
      if 0.0 < u and u < d:
        result.max = abs(t - c)
      else:
        result.max=min(abs(p[i] - c), abs(q[i] - c))
  let D = 0.0
  proc f_x(x:float):float = # xを固定して最小の半径を求める
    proc f0(y:float):float = f(x, y)
    let (y0, v) = goldenSectionSearch(f0, 0.0 - D, 1000.0 + D)
    return v
  let
    (x, v) = goldenSectionSearch(f_x, 0.0 - D, 1000.0 + D)
  #debug x, v
  echo v
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  var c = newSeqWith(N, 0)
  var d = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
    d[i] = nextInt()
  solve(N, a, b, c, d)
else:
  discard

