when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, X:int, Y:seq[int], Z:seq[int]):
  var
    v = Seq[tuple[x, i:int]]
  v.add (0, -1)
  v.add (X, -1)
  for i in N:
    v.add (Y[i], i) # 壁の位置
    v.add (Z[i], -1) # ハンマーの位置
  v.sort
  var si = 0
  while v[si].x != 0:
    si.inc
  var dp = Seq[v.len, v.len: int.inf]
  dp[si][si] = 0
  for r in si ..< v.len:
    for l in 0 .. si << 1:
      # l, r -> (l, r + 1), (l - 1, r)
      # r, l -> (r + 1, l), (r, l - 1)
      # r -> r + 1に行く
      if dp[l][r] < int.inf:
        if r + 1 < v.len:
          let i = v[r].i
          if i == -1 or Z[i] in v[l].x .. v[r].x: # rを超えるための鍵を持ってる
            let d = v[r + 1].x - v[r].x
            dp[l][r + 1].min=dp[l][r] + d
        if l - 1 >= 0:
          let i = v[l].i
          if i == -1 or Z[i] in v[l].x .. v[r].x: # lを超えるための鍵を持ってる
            let d = v[r].x - v[l - 1].x
            dp[r][l - 1].min=dp[l][r] + d
      if dp[r][l] < int.inf:
        if l - 1 >= 0:
          let i = v[l].i
          if i == -1 or Z[i] in v[l].x .. v[r].x: # lを超えるための鍵を持ってる
            let d = v[l].x - v[l - 1].x
            dp[r][l - 1].min=dp[r][l] + d
        if r + 1 < v.len:
          let i = v[r].i
          if i == -1 or Z[i] in v[l].x .. v[r].x: # rを超えるための鍵を持ってる
            let d = v[r + 1].x - v[l].x
            dp[l][r + 1].min=dp[r][l] + d
  var xi = 0
  while v[xi].x != X: xi.inc
  var ans = int.inf
  for i in v.len:
    ans.min=dp[i][xi]
    ans.min=dp[xi][i]
  echo if ans == int.inf: -1 else: ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var Y = newSeqWith(N, nextInt())
  var Z = newSeqWith(N, nextInt())
  solve(N, X, Y, Z)
else:
  discard

