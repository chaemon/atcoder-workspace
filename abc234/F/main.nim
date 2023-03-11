import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL 
Please use Nim-ACL
Please use Nim-ACL

const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(S:string):
  var ct = Seq[26:0]
  for s in S: ct[s.ord - 'a'.ord].inc
  var dp = @[mint(1)]
  for i in 26:
    var dp2 = Seq[dp.len + ct[i] + 1 :mint(0)]
    for j in dp.len:
      for k in ct[i] + 1:
        dp2[j + k] += dp[j] * mint.rfact(k)
    swap dp, dp2
  var ans = mint(0)
  for i in dp.len:
    ans += mint.fact(i) * dp[i]
  echo ans - 1
  discard

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

