when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils
import atcoder/dsu

solveProc solve(N:int, M:int, S:seq[string]):
  var memo = initTable[(seq[int8], int), (seq[int8], bool)]()
  proc getNext(a:seq[int8], b:int):tuple[next: seq[int8], ended: bool] =
    if (a, b) in memo:
      return memo[(a, b)]
    # next: 次の状態
    # ended: 繋がっていない
    var uf = initDSU(M)
    let u = a.max
    var v = M @ false
    var adj = u + 1 @ seq[int8]
    for i in a.len:
      if a[i] == -1: continue
      adj[a[i]].add int8(i)
    var
      vis = [3, M] @ int8(-1)
      c = int8(0)
    proc valid(t, x:int):bool =
      if x notin 0 ..< M: return false
      case t:
        of 0:
          discard
        of 1:
          if a[x] == -1: return false
        of 2:
          if b[x] == 0: return false
        else:
          doAssert false
      return true
    proc dfs(t, x:int, c:int8) = # t = 0: aのindex, t = 1: 前の列, t = 2: 次の列
      if not valid(t, x): return
      if vis[t][x] >= 0: return
      vis[t][x] = c
      if t >= 1:
        dfs(t, x - 1, c)
        dfs(t, x + 1, c)
      case t:
        of 0:
          # 0 -> 1
          for y in adj[x]:
            dfs(1, y, c)
        of 1:
          # 1 -> 0
          dfs(0, a[x], c)
          # 1 -> 2
          dfs(2, x, c)
        of 2:
          dfs(1, x, c)
        else:
          doAssert false
      discard
    for x in M:
      if b[x] == 0 or vis[2][x] >= 0: continue
      dfs(2, x, c)
      c.inc
    var
      next = M @ int8(-1)
      ended = false
    for x in M:
      next[x] = vis[2][x]
    for t in 0 .. u:
      if vis[0][t] == -1: ended = true
    memo[(a, b)] = (next, ended)
    return (next, ended)

  proc isEmpty(i:int):bool =
    for j in M:
      if S[i][j] == '#': return false
    return true
  var v = @(int)
  for i in N:
    if not isEmpty(i): v.add i
  let
    m0 = v.min
    m1 = v.max
  var dp = initTable[seq[int8], int]()
  dp[M @ int8(-1)] = 0

  for s in m0 .. m1:
    var dp2 = initTable[seq[int8], int]()
    for b in 2^M:
      block:
        # Sで#のところのビットはたってないといけない
        ok := true
        for i in M:
          if S[s][i] == '#' and b[i] == 0:
            ok = false
        if not ok: continue
      # 新たに追加するブロックの数
      let d = block:
        var d = 0
        for i in M:
          if S[s][i] == '.' and b[i] == 1:
            d.inc
        d
      for a, t in dp:
        var (na, e) = getNext(a, b)
        if e: continue
        if na notin dp2: dp2[na] = int.inf
        dp2[na].min= d + t
    dp = dp2.move
  ans := int.inf
  for a, t in dp:
    if a.max > 0: continue
    ans.min= t
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, M, S)
else:
  discard

