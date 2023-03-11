include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 2
type mint = modint2

proc solve(N:int, a:seq[int], b:seq[int], c:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
  var c = newSeqWith(N, nextInt())
  solve(N, a, b, c)
#}}}
