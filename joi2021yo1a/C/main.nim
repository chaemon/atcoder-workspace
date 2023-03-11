include atcoder/extra/header/chaemon_header


proc solve(N:int, M:int, A:seq[int], B:seq[int]) =
  for i in 1..100:
    if i in A and i in B:
      echo i
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
#}}}
