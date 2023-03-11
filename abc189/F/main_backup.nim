include atcoder/extra/header/chaemon_header

import atcoder/extra/dp/cumulative_sum
import atcoder/extra/other/binary_search_float

proc solve(N:int, M:int, K:int, A:seq[int]) =
  var furidashi = Seq(N + 1, false)
  var cs = initCumulativeSum(N + 10, int, false)
  for i in 0..<K:
    furidashi[A[i]] = true
    cs[A[i]] = 1
  for i in 0..<N:
    if cs[i+1..i+M] == M:
      echo -1;return
  proc f(e:float):bool =
    var cs = initCumulativeSum(N + 10, float, true)
    var prev = 0.0
    for i in countdown(N, 0):
      var x = 0.0
      if i < N:
        if furidashi[i]:
          x = e
        else:
          x = cs[i+1..i+M] / M.float + 1.0
      cs[i] = x
      prev = x
    return prev >= e
  echo f.maxRight(0.0..1e+15)
#  echo f.minLeft(0.0..10000000000.0)
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt())
  solve(N, M, K, A)
#}}}
