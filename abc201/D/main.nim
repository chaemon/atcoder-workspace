include atcoder/extra/header/chaemon_header


const DEBUG = true

# Failed to predict input format
block main:
  let H, W = nextInt()
  let A = Seq[H: nextString()]
  var
    vis = Seq[H, W: false]
    dp = Seq[H, W: int]
  D(s:char) => (if s == '+': 1 else: 0)
  proc calc(i, j:int):int =
    if vis[i][j]: return dp[i][j]
    if i == H - 1 and j == W - 1: return 0
    vis[i][j] = true
    if (i + j) mod 2 == 0: # takahashi
      dp[i][j] = -int.inf
      if i + 1 in 0..<H:
        dp[i][j].max=calc(i+1, j) + D(A[i+1][j])
      if j + 1 in 0..<W:
        dp[i][j].max=calc(i, j+1) + D(A[i][j+1])
    else: # aoki
      dp[i][j] = int.inf
      if i + 1 in 0..<H:
        dp[i][j].min=calc(i+1, j) - D(A[i+1][j])
      if j + 1 in 0..<W:
        dp[i][j].min=calc(i, j+1) - D(A[i][j+1])
    assert dp[i][j] != int.inf and dp[i][j] != -int.inf
    return dp[i][j]
  let r = calc(0, 0)
  if r > 0:
    echo "Takahashi"
  elif r < 0:
    echo "Aoki"
  else:
    echo "Draw"
  discard

