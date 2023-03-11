include atcoder/extra/header/chaemon_header


proc solve(N:int, M:int, A:seq[int], B:seq[int], U:seq[int], V:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
  solve(N, M, A, B, U, V)
#}}}
