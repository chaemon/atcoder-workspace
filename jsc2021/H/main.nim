include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, M:int, A:seq[int], C:seq[int], X:seq[int], Y:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    C[i] = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, A, C, X, Y)
#}}}

