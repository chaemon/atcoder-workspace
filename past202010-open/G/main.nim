include atcoder/extra/header/chaemon_header


const DEBUG = true

# Failed to predict input format
block main:
  let N, M = nextInt()
  var S = newSeqWith(N, nextString())
  var vis = Seq[N, M: bool]
  var x0, y0:int
  proc dfs(x, y:int) =
    if vis[x][y]: return
    vis[x][y] = true
    for d in [[0, 1], [0, -1], [1, 0], [-1, 0]]:
      let
        x2 = x + d[0]
        y2 = y + d[1]
      if x2 notin 0..<N or y2 notin 0..<M or S[x2][y2] == '#':continue
      dfs(x2, y2)
  var ans = 0
  for i in 0..<N:
    for j in 0..<M:
      if S[i][j] == '#':
        S[i][j] = '.'
        vis = Seq[N, M:false]
        dfs(i, j)
        valid := true
        for i2 in 0..<N:
          for j2 in 0..<M:
            if S[i2][j2] == '.' and not vis[i2][j2]: valid = false
        if valid: ans.inc
        S[i][j] = '#'
  echo ans
  discard

