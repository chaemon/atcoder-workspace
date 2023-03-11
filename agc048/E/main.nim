include atcoder/extra/header/chaemon_header

const MOD = 1000000007

proc solve(N:int, K:int, T:int, B:seq[seq[int]]) =
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var T = nextInt()
  var B = newSeqWith(N, newSeqWith(K, nextInt()))
  solve(N, K, T, B)
#}}}
