const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

solveProc solve(N:int, M:int):
  var dp = initTable[int, mint]()
  proc calc(x:int):mint =
    if x in dp: return dp[x]
    result = mint(N)
    var lmin = min(N + 1, x + 1)
    For (var j = 1;var x:int), j * j <= N, j.inc:
      # j <= x / i < j + 1 となるiの範囲 l ..< r
      var
        l = max(x div (j + 1) + 1, 2)
        r = min(x div j + 1, N + 1)
      if l >= r: continue
      lmin.min=l
      result += calc(j) * (r - l)
    For (var i = 2), i < lmin, i.inc:
      result += calc(x div i)
    result /= N - 1
    dp[x] = result
  echo calc(M)
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

