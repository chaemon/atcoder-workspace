include atcoder/extra/header/chaemon_header


proc solve(N:int, R:seq[int], H:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var R = newSeqWith(N, 0)
  var H = newSeqWith(N, 0)
  for i in 0..<N:
    R[i] = nextInt()
    H[i] = nextInt()
  solve(N, R, H)
#}}}
