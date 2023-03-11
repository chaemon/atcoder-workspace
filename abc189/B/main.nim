include atcoder/extra/header/chaemon_header


proc solve(N:int, X:int, V:seq[int], P:seq[int]) =
  var c = 0.0
  for i in 0..<N:
    c += V[i].float * P[i].float / 100.0
    if c > X.float + 1e-9:
      echo i + 1;return
  echo -1
  return

# input part {{{
block:
  var N = nextInt()
  var X = nextInt()
  var V = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    V[i] = nextInt()
    P[i] = nextInt()
  solve(N, X, V, P)
#}}}
