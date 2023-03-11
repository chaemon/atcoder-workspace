include atcoder/extra/header/chaemon_header


proc solve(N:int, M:int, C:seq[int], A:seq[int], B:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var C = newSeqWith(M, 0)
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    C[i] = nextInt()
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, C, A, B)
#}}}
