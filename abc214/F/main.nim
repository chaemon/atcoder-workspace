const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
#type mint = modint
#mint.setMod(MOD)
type mint = modint1000000007

solveProc solve(S:string):
  var next_dp = Seq[S.len + 1, 26: -1]
  proc next(i:int, c:char):int =
    let j = c.ord - 'a'.ord
    ret =& next_dp[i][j]
    if ret >= 0: return ret
    if i == S.len: ret = S.len
    else:
      if S[i] == c: ret = i
      else: ret = next(i + 1, c)
    return ret
  var dp = Seq[S.len: mint(0)]
  for c in 'a'..'z':
    let t = next(0, c)
    if t != S.len: dp[t].inc
  var ans = mint(0)
  for i in 0..<S.len:
    ans += dp[i]
    for c in 'a'..'z':
      var t = next(i + 1, c)
      if t == i + 1:
        if i + 2 <= S.len:
          t = next(i + 2, c)
          if t != S.len:
            dp[t] += dp[i]
      elif t != S.len:
        dp[t] += dp[i]
  echo ans
  return

when not DO_TEST:
  var S = nextString()
  solve(S)
