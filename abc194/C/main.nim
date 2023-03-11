include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, A:seq[int]) =
  S := 0
  T := 0
  for i in 0..<N:
    S += A[i]
    T += A[i]^2
  echo N * T - S^2
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
#}}}

