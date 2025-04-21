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

solveProc solve(N:int, A:seq[int]):
  var a = Seq[1001: seq[int]]
  for n in A:
    block:
      var n = n
      for p in 2 .. n:
        if n mod p == 0:
          e := 0
          while n mod p == 0: n.div=p;e.inc
          a[p].add e
  for p in 2 .. 1000:
    if a[p].len == 0: continue
    # 各々+kか-kを決める
    # 1 1 -> 1, 2, 4
    # 1 -1 -> 1, 2, 1
    # -1 1 -> 2, 1, 2
    # -1 -1 -> 4, 2, 1
    debug p, a[p]


  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N-1, nextInt())
  solve(N, A)
else:
  discard

