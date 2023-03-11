include atcoder/extra/header/chaemon_header

import atcoder/extra/dp/cumulative_sum
import atcoder/extra/other/binary_search_float

type P = (float, float)
converter toP(a:int):P = (0.0, a.float)
proc `+=`(x:var P, y:P) =
  x[0] += y[0]
  x[1] += y[1]
`-`(x, y:P) => (x[0] - y[0], x[1] - y[1])

proc solve(N:int, M:int, K:int, A:seq[int]) =
  var furidashi = Seq(N + 1, false)
  var cs = initCumulativeSum(N + 10, int, false)
  for i in 0..<K:
    furidashi[A[i]] = true
    cs[A[i]] = 1
  for i in 0..<N:
    if cs[i+1..i+M] == M:
      echo -1;return
  block:
    var cs = initCumulativeSum(N + 10, (float, float), true)
    var prev:(float, float)
    for i in countdown(N, 0):
      var x:(float, float)
      if i < N:
        if furidashi[i]:
          x = (0.0, 1.0)
        else:
          x = cs[i+1..i+M]
          x[0] /= M.float
          x[1] /= M.float
          x[0] += 1.0
      cs[i] = x
      prev = x
    prev[1] -= 1.0
    echo -prev[0] / prev[1]
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
