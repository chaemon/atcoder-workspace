include atcoder/extra/header/chaemon_header


proc solve() =
  let N, M = nextInt()
  let A = Seq(N, nextInt())
  let B = Seq(M, nextInt())
  var dp = Seq(N + 1, M + 1, int)
  var vis = Seq(N + 1, M + 1, false)
  proc calc(x, y:int):int =
    if vis[x][y]: return dp[x][y]
    vis[x][y] = true
    if x == 0 and y == 0:
      result = 0
      dp[x][y] = 0
      return 
    result = int.inf
    if x > 0:
      result.min=calc(x - 1, y) + 1
    if y > 0:
      result.min=calc(x, y - 1) + 1
    if x > 0 and y > 0:
      var t = calc(x - 1, y - 1)
      if A[x - 1] != B[y - 1]:
        t.inc
      result.min=t
    dp[x][y] = result
  echo calc(N, M)
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
