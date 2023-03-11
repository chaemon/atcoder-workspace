include atcoder/extra/header/chaemon_header

proc solve(N:int, A:seq[int], B:seq[int]) =
  var S = -A.sum
  var v = collect(newSeq):
    for i in 0..<N: B[i] + A[i] * 2
  v.sort(Descending)
  for i in 0..<N:
    S += v[i]
    if S > 0: echo i + 1;break
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
#}}}
