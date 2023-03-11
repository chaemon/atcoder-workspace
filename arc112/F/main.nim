include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1
type mint = modint1

const DEBUG = true

proc solve(n:int, m:int, c:seq[int], s:seq[seq[int]]) =
  return

# input part {{{
block:
  var n = nextInt()
  var m = nextInt()
  var c = newSeqWith(n, nextInt())
  var s = newSeqWith(m, newSeqWith(n, nextInt()))
  solve(n, m, c, s)
#}}}

