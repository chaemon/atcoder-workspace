include atcoder/extra/header/chaemon_header


proc solve(N:int, E:int, A:seq[int], L:seq[int], R:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var E = nextInt()
  var A = newSeqWith(N, nextInt())
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, E, A, L, R)
#}}}
