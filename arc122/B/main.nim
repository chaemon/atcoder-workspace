include atcoder/extra/header/chaemon_header

import atcoder/extra/dp/cumulative_sum

const DEBUG = false

const cat = true
var p:int
when cat: p = 10

proc solve(N:int, A:seq[int]) =
  if N == 1:
    echo A[0].float / 2
    return
  var
    A = A
    s = 0.0 # sum of Ai
    cs = initCumulativeSum(N, float)
  A.sort
  var ans = (A.sum).float
  for i in 0..<N: cs[i] = A[i]
  for i in 0 ..< N - 1:
    # 2x is between A[i] .. A[i + 1]
    # left: i
    # right: N - i
    # (i + 1) * x + cs[i + 1 ..< N] - (N - (i + 1)) * x
    let d = (i + 1) - (N - (i + 1))
    var x:float
    if d >= 0:
      x = A[i].float / 2
    else:
      x = A[i + 1].float / 2
    debug i, d, x
    ans.min= d * x + cs[i + 1 ..< N]
  echo ans / N
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

