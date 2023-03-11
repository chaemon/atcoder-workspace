include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, M:int, K:int, Q:int, P:seq[int], T:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var Q = nextInt()
  var P = newSeqWith(N, 0)
  var T = newSeqWith(N, 0)
  for i in 0..<N:
    P[i] = nextInt()
    T[i] = nextInt()
  solve(N, M, K, Q, P, T)
#}}}

