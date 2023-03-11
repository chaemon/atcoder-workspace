include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils

const DEBUG = true

proc solve(N:int, A:seq[int]) =
  ans := int.inf
  for b in 2^(N - 1):
    var v = @[0]
    for i in 0..<N - 1:
      if b[i]: v.add i + 1
    v.add N
    var s = 0
    for i in v.len - 1:
      var s0 = 0
      for j in v[i]..<v[i+1]:
        s0 = s0 or A[j]
      s = s xor s0
    ans.min=s
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

