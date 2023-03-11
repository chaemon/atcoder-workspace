const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import BigNum
import lib/dp/cumulative_sum
import lib/other/binary_search

const EPS = 1e-10
const B = 54800

proc sqSum(n:Int):Int =
  return n * (n + 1) * (2 * n + 1) div 6
proc sqSum(a, b:Int):Int =
  return sqSum(b) - sqSum(a - 1)

proc calc_sqrt_int(n:int):int =
  proc f(a:int):bool =
    a * a <= n
  return f.max_right(0 .. 3 * 1000000001)

# Failed to predict input format
solveProc solve(X:int):
  var cs = initCumulativeSum[int](B)
  cs[1] = 1
  for Y in 2 ..< B:
    #let Y2 = int(sqrt(float(Y)) + EPS)
    let Y2 = calc_sqrt_int(Y)
    cs[Y] = cs[1..Y2]
  var ans = newInt(0)
  # X -> 1
  ans += 1
  # X -> a -> 1 (a >= 2)
  #ans += (int(sqrt(float(X)) + EPS) - 2 + 1)
  ans += (calc_sqrt_int(X) - 2 + 1)
  var a = 2
  #let bmax = int(sqrt(float(X)) + EPS)
  let bmax = calc_sqrt_int(X)
  # X -> ?? -> a
  while a^4 <= X:
    var d = newInt(bmax - a * a + 1)
    d *= cs[a..a]
    ans += d
    a.inc
  echo ans
  Naive:
    var cs = initCumulativeSum[int](X + 1)
    cs[1] = 1
    for Y in 2 .. X:
      #let Y2 = int(sqrt(float(Y)) + EPS)
      let Y2 = calc_sqrt_int(Y)
      cs[Y] = cs[1..Y2]
    echo cs[X..X]
  discard

when not DO_TEST:
  let T = nextInt()
  for _ in T:
    let X = nextInt()
    solve(X)
else:
  for X in B - 10..B + 1000:
    echo "test: ", X
    test(X)

