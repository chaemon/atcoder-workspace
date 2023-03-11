include atcoder/extra/header/chaemon_header

const MOD = 998244353

proc solve(N:int, M:int, a:seq[int], b:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, M, a, b)
#}}}
