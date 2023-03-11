const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import lib/other/floatutils
import atcoder/extra/other/decimal_mpfr
#import atcoder/extra/math/longdouble

#type float = LongDouble
type float = Decimal
type P = tuple[x, y, z:float]

proc `-`(v, w: P):P =
  (v.x - w.x, v.y - w.y, v.z - w.z)

proc abs(v:P):float =
  sqrt(v.x * v.x + v.y * v.y + v.z * v.z)

block:
  var
    I = newcmpfr(Decimal(0), Decimal(1))
    u = I * newCmpfr(pi(), Decimal(0))
  debug u
  echo exp(u)
  let t = newCmpfr(Decimal(0), Decimal(0.0371))
  echo sin(arcsin(t))
  echo cos(arccos(t))
  echo tan(arctan(t))

solveProc solve(T:int, L:int, X:int, Y:int, Q:int, E:seq[int]):
  let
    r = float(L) / float(2)
    cx = float(0)
    cy = r
    #PI = pi()
    PI = arccos(float(-1))
  #echo "PI = ", PI
  for E in E:
    let theta = (E mod T) / T * PI * float(2)
    let
      s:P = (float(0), cx - sin(theta) * r, cy - cos(theta) * r)
      t:P = (float(X), float(Y), float(0))
      v = t - s
    var w = v
    w[2] = float(0)
    let p = v.x * w.x + v.y * w.y + v.z * w.z
    echo (arccos(p / v.abs / w.abs) / PI * 180.0).toStr(30)
  return

when not DO_TEST:
  var T = nextInt()
  var L = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var Q = nextInt()
  var E = newSeqWith(Q, nextInt())
  solve(T, L, X, Y, Q, E)
