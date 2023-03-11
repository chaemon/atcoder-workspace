const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int], I:seq[int]):
  if P[0] != 0:
    echo -1;return

  var
    ans = Seq[N: (int, int)]
    ok = true
    pos = Seq[N: int]
  for i in N:
    pos[I[i]] = i
  proc dfs(p0, i0: Slice[int]):int =
    if p0.len == 0: return -1
    let
      (pl, pr) = (p0.a, p0.b + 1)
      (il, ir) = (i0.a, i0.b + 1)
    let
      u = P[pl]
      i = pos[u]
    if i notin i0:
      ok = false; return
    let d = i - il
    doAssert I[i] == u
    let l = dfs(pl + 1 .. pl + d, il ..< il + d)
    if not ok: return -1
    let r = dfs(pl + d + 1 ..< pr, il + d + 1 ..< ir)
    if not ok: return -1
    ans[u] = (l, r)
    return u
  discard dfs(0 ..< N, 0 ..< N)
  if not ok:
    echo -1
  else:
    for i in 0 ..< ans.len:
      echo ans[i][0] + 1, " ", ans[i][1] + 1
  discard

when not DO_TEST:
  var N = nextInt()
  var P = newSeqWith(N, nextInt() - 1)
  var I = newSeqWith(N, nextInt() - 1)
  solve(N, P, I)
else:
  discard

