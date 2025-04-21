when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(H:int, W:int, A:seq[seq[int]], Q:int, sh:int, sw:int, d:seq[string], a:seq[int]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, newSeqWith(W, nextInt()))
  var Q = nextInt()
  var sh = nextInt()
  var sw = nextInt()
  var d = newSeqWith(Q, "")
  var a = newSeqWith(Q, 0)
  for i in 0..<Q:
    d[i] = nextString()
    a[i] = nextInt()
  solve(H, W, A, Q, sh, sw, d, a)
else:
  discard

