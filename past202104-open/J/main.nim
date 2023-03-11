include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, C:int, X:seq[int], Y:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var C = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, C, X, Y)
#}}}

