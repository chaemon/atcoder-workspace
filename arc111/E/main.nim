include atcoder/extra/header/chaemon_header

import atcoder/math

proc ceilDiv[T:SomeInteger](a, b:T):T =
  result = floorDiv(a, b)
  if a mod b != 0: result.inc

proc solve(A, B, C, D:int) =
  let N = ceilDiv((B * (D - A) + C * A),  C * D - B * D) - 1
  var s = 0
  if N > 0:
    s += floor_sum(N, C, D, D * 2 - A + C - 1) - floor_sum(N, B, D, D - A) - N
  s += ceilDiv(D - A, C) - 1
  echo s

proc solve(T:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]) =
  for i in T:
    solve(A[i], B[i], C[i], D[i])
  return

# input part {{{
block:
  var T = nextInt()
  var A = newSeqWith(T, 0)
  var B = newSeqWith(T, 0)
  var C = newSeqWith(T, 0)
  var D = newSeqWith(T, 0)
  for i in 0..<T:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(T, A, B, C, D)
#}}}
