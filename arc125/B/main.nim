const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header


import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int):
  var ans = 0
  for k in 1..N:
    let t = N div k - k
    if t < 0: break
    ans += t div 2 + 1
    ans.mod= MOD
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)

