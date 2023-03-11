const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(S:string):
  let N = S.len
  var ans = mint(0)
  for i in N:
    var t = S[i].ord - '0'.ord
    let K = N - i - 1
    var d = mint(0)
    if K > 0:
      let r = mint(10) / mint(2)
      d += t * mint(2)^(K - 1) * (1 - r^K) / (1 - r)
    d += t * mint(10)^K
    d *= mint(2)^i
    ans += d
  echo ans
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
else:
  discard

