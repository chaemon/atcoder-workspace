include atcoder/extra/header/chaemon_header


proc solve(N:int, S:seq[string]) =
  var ans = 0.0
  var vis:seq[bool]
  proc dfs(u:int) =
    if vis[u]: return
    vis[u] = true
    for v in 0..<N:
      if S[v][u] == '0': continue
      dfs(v)
  for u in 0..<N:
    vis = Seq(N, false)
    dfs(u)
    ans += 1.0/vis.count(true).float
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, S)
#}}}
