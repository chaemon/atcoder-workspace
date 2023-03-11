include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

const DEBUG = true
proc solve(N:int, A:seq[int]):mint =
  var num_p, num_m = mint(0)
  var sum_p, sum_m = mint(0)
  num_p = 1
  sum_p = A[0]
  for i in 1..<N:
    var num_p2, num_m2 = mint(0)
    var sum_p2, sum_m2 = mint(0)
    # set plus
    num_p2 += num_p + num_m
    sum_p2 += sum_p + A[i] * num_p + sum_m + A[i] * num_m
    # set minus
    num_m2 += num_p
    sum_m2 += sum_p - A[i] * num_p
    swap num_p, num_p2
    swap num_m, num_m2
    swap sum_p, sum_p2
    swap sum_m, sum_m2
  echo sum_p + sum_m

#proc solve(N:int, A:seq[int]):mint =
#  var f = Seq[N + 1: mint]
#  f[0] = 1
#  f[1] = 2
#  for n in 2..N: f[n] = f[n - 1] + f[n - 2]
#  var ans = mint(0)
#  for i in 0..<N:
#    # set plus
#    if i == 0:
#      ans += f[N - 1 - i] * A[i]
#    else:
#      ans += f[i - 1] * f[N - 1 - i] * A[i]
#    # set minus
#    if i >= 1:
#      if i == 1:
#        ans -= f[N - i - 2] * A[i]
#      elif i == N - 1:
#        ans -= f[i - 2] * A[i]
#      else:
#        ans -= f[i - 2] * f[N - i - 2] * A[i]
#  echo ans
#  return ans

const DO_TEST = false
when DO_TEST:
  proc solve_naive(N:int, A:seq[int]):mint =
    var s = mint(0)
    for b in 2^(N - 1):
      var valid = true
      for i in 0..<N - 2:
        if b[i] and b[i + 1]: valid = false
      if not valid: continue
      s += A[0]
      for i in 0..<N - 1:
        if b[i]: s -= A[i + 1]
        else: s += A[i + 1]
    return s

  proc test() =
    var A = @[1000000000,1000000000,1000000000]
    let N = A.len
    doAssert solve(N, A) == solve_naive(N, A)
  test()
else:
  block:
    var N = nextInt()
    var A = newSeqWith(N, nextInt())
    discard solve(N, A)



