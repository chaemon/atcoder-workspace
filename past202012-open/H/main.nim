include atcoder/extra/header/chaemon_header

import atcoder/extra/other/direction

solveProc solve(H:int, W, r:int, c:int, s:seq[string]):
  var vis = Seq[H, W: false]
  proc dfs(i, j:int) =
    if vis[i][j]: return
    vis[i][j] = true
    for (i0, j0) in (i, j).neighbor(dir4):
      if i0 notin 0..<H or j0 notin 0..<W: continue
      if s[i0][j0] == '#': continue
      if s[i0][j0] == '<' and j0 - 1 != j: continue
      if s[i0][j0] == '^' and i0 - 1 != i: continue
      if s[i0][j0] == '>' and j0 + 1 != j: continue
      if s[i0][j0] == 'v' and i0 + 1 != i: continue
      dfs(i0, j0)
  dfs(r, c)
  var ans = Seq[H: "#".repeat(W)]
  for i in H:
    for j in W:
      if s[i][j] == '#': continue
      ans[i][j] = if vis[i][j]: 'o' else: 'x'
  echo ans.join("\n")
  return

let H, W = nextInt()
let r, c = nextInt() - 1
let s = Seq[H: nextString()]

solve(H, W, r, c, s, true)
