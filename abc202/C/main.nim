include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int], C:seq[int]) =
  var sa , sb = Seq[N: int]
  var ans = 0
  for i in 0..<N:
    sa[A[i]].inc
  for j in 0..<N:
    sb[B[C[j]]].inc
  for i in 0..<N:
    ans += sa[i] * sb[i]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt() - 1)
  var B = newSeqWith(N, nextInt() - 1)
  var C = newSeqWith(N, nextInt() - 1)
  solve(N, A, B, C)
#}}}

