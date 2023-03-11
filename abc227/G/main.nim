const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/eratosthenes

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, K:int):
  var es = initEratosthenes()
  proc calc(t:int):Table[int, int] =
    # t, t + 1, ..., t + K - 1
    var a = (t ..< t + K).toSeq
    var i = 0
    result = initTable[int, int]()
    while true:
      var p = es[i]
      if p > 10^6: break
      var r = t mod p
      var j:int
      if r == 0:
        j = 0
      else:
        j = p - r
      while j < a.len:
        while a[j] mod p == 0:
          result[p].inc
          a[j].div=p
        j += p
      i.inc
    for p in a:
      if p > 1: result[p].inc
  var 
    a = calc(N - K + 1)
    b = calc(1)
  for p, e in b:
    a[p] -= e
  var ans = mint(1)
  for p, e in a:
    ans *= e + 1
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  discard

