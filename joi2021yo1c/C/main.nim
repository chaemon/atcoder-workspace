include atcoder/extra/header/chaemon_header

iterator items(n:int):int =
  for i in 0..<n: yield i

proc solve(N:int, M:int, A:seq[int], B:seq[int]) =
  var ans = 0
  for i in N:
    for j in M:
      if A[i] <= B[j]: ans.inc
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
#}}}
