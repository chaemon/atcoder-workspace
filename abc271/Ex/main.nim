when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
  #const DO_CHECK = true;const DEBUG = true
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/math/simplex
import lib/math/longdouble
import lib/other/decimal_gmp
import lib/other/decimal
import lib/other/floatutils

#import BigNum
#
#type S = object
#  a:Rat
#
#block:
#  var
#    a = newRat(2, 3)
#    b = newRat(1, 4)
#  a = b
#  echo a
#  echo a + b


var d = [
  [1, 0],
  [1, 1],
  [0, 1],
  [-1, 1],
  [-1, 0],
  [-1, -1],
  [0, -1],
  [1, -1]
]

Decimal.initPrec(1000)

#block:
#  echo "e = ", exp(Decimal(1))
#  echo cos(arccos(Decimal(0.5)))
#  echo sin(arcsin(Decimal(0.5)))
#  echo tan(arctan(Decimal(0.5)))

#type float = float128
type float = Decimal

solveProc solve(A, B:int, s:string):
  id := Seq[int]
  for i in 8:
    if s[i] == '0': continue
    id.add i
  var A0 = Seq[2, id.len: float(0)]
  var
    b = @[float(A), float(B)]
    c = Seq[id.len: float(1)]
  for i in id.len:
    A0[0][i] = float(d[id[i]][0])
    A0[1][i] = float(d[id[i]][1])
  let (status, v, x) = twoStageSimplex(A0, b, c)
  if status == Optimal:
    #debug A0, b, c
    debug v, x
    var ans = $((v + Decimal(0.5)).floor)
    block:
      # c^T xがvになっているか？
      var s = Decimal(0)
      for i in x.len:
        s += c[i] * x[i]
      doAssert s - v < Decimal.getEps() and v - s < Decimal.getEps()
      for i in x.len:
        let t = (x[i] + 0.5).floor
        doAssert t - x[i] < Decimal.getEps() and x[i] - t < Decimal.getEps()
    #debug Decimal.getEps()
    let i = ans.find(".")
    if i >= 0:
      ans = ans[0 ..< i]
    echo ans
  else:
    echo -1

#block:
#  let T = nextInt()
#  for _ in T:
#    let A, B = nextInt()
#    let s = nextString()
#    solve(A, B, s)

import random
block:
  #let s = "11111111"
  #solve(1, 1, "11000111")
  #solve(1, 1, "01000001")
  solve(1, 2, "01011101")
  #randomize()
  #while true:
  #  s := ""
  #  for i in 8:
  #    if random.rand(0..1) == 0:
  #      s.add '0'
  #    else:
  #      s.add '1'
  #  let
  #    A = random.rand(1 .. 3)
  #    B = random.rand(1 .. 3)
  #  debug A, B, s
  #  solve(A, B, s)
