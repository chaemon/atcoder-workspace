include atcoder/extra/header/chaemon_header

import atcoder/extra/dp/dual_cumulative_sum
import atcoder/extra/other/compress

proc solve(N:int, C:int, a:seq[int], b:seq[int], c:seq[int]) =
  var
    a = a
    b = b
  for i in 0..<N:b[i].inc
  var v = initCompress(a, b)
  cs := initDualCumulativeSum[int](v.len)
  for i in 0..<N:
    let ai = v.id(a[i])
    let bi = v.id(b[i])
    cs.add(ai..<bi, c[i])

  var ans = 0
  for i in 0..<v.len-1:
    if cs[i] > C:
      ans += (v[i + 1] - v[i]) * C
    else:
      ans += (v[i + 1] - v[i]) * cs[i]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var C = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  var c = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
  solve(N, C, a, b, c)
#}}}
