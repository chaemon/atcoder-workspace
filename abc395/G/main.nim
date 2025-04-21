when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils, lib/graph/graph_template
import std/heapqueue

solveProc solve(N:int, K:int, C:seq[seq[int]], Q: int, s, t:seq[int]):
  Pred s, t
  proc calc(s:int):seq[seq[int]] =
    var ids = (0 ..< K).toSeq & s
    let K = K + 1
    var
      dp = Seq[2^K, N: int.inf] # dp[b][u]: bとuをつなぐコスト
    for ui in K:
      dp[1 shl ui][ids[ui]] = 0
    for b in 1 ..< 2^K:
      # bの部分集合について: 3^9 * 80
      for u in N:
        for b2 in b.subsets:
          if b2 == 0 or b == b2: continue
          dp[b][u].min=dp[b2][u] + dp[b xor b2][u]
      # dp[b][u]を辺で確定(小さい順): 80 * 80 * log
      var
        q = initHeapQueue[tuple[d, u:int]]()
        vis = Seq[N: false]
      for u in N:
        q.push (dp[b][u], u)
      while q.len > 0:
        let (d, u) = q.pop()
        if vis[u]: continue
        vis[u] = true
        for v in N:
          let d2 = dp[b][u] + C[u][v]
          if d2 < dp[b][v]:
            dp[b][v] = d2
            q.push (d2, v)
    return dp
  var dps = Seq[seq[seq[int]]]
  for s in K ..< N:
    dps.add calc(s)
  for i in Q:
    let (s, t) = (s[i], t[i])
    echo dps[s - K][(1 shl (K + 1)) - 1][t]
  discard

when not defined(DO_TEST):
  var
    N, K = nextInt()
    C = Seq[N, N: nextInt()]
    Q = nextInt()
    s, t = Seq[Q: int]
  for i in Q:
    s[i] = nextInt()
    t[i] = nextInt()
  solve(N, K, C, Q, s, t)
else:
  discard

