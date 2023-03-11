const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(H:int, W:int, B:seq[seq[int]]):
  discard

when not DO_TEST:
  var H = nextInt()
  var W = nextInt()
  var B = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, B)
else:
  discard

