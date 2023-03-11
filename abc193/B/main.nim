include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int], P:seq[int], X:seq[int]) =
  ans := int.inf
  for i in 0..<N:
    if A[i] < X[i]:
      ans.min=P[i]
  if ans == int.inf:
    echo -1
  else:
    echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    P[i] = nextInt()
    X[i] = nextInt()
  solve(N, A, P, X)
#}}}

