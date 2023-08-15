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
solveProc solve(S:string):
  var
    a = 26 @ S.len
    next:seq[seq[int]]
  next.add a
  for i in 0 ..< S.len << 1:
    a[S[i] - 'a'] = i
    next.add a
  next.reverse
  var ans = mint(0)
  for t in 1 ..< S.len:
    var dp = [S.len + 1, S.len + 1] @ mint(0)
    let i0 = next[0][S[t] - 'a']
    if i0 >= t: continue
    dp[i0][t] = 1
    for i in 0 ..< t:
      for j in t ..< S.len:
        if dp[i][j] == 0: continue
        if next[i + 1][S[t] - 'a'] == t:
          ans += dp[i][j]
        for c in 26:
          let
            i1 = next[i + 1][c]
            j1 = next[j + 1][c]
          if i1 >= t or j1 >= S.len: continue
          dp[i1][j1] += dp[i][j]
  echo ans
  discard

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

