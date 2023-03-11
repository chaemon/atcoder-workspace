include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, P:seq[int], U:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var P = newSeqWith(N, 0)
  var U = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
    U[i] = nextInt()
  solve(N, P, U)
#}}}

