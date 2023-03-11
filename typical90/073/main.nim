const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, c:seq[string], a:seq[int], b:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var c = newSeqWith(N, nextString())
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, c, a, b)
#}}}

