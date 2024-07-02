when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  Pred A, B
  var adj = Seq[N: seq[tuple[u, d:int]]]# adj[i][j]
  for i in M:
    adj[A[i]].add (B[i], -C[i]) # A[i] -> B[i]で+C[i]
    adj[B[i]].add (A[i], C[i])
  var vis = Seq[N: false]
  proc dfs(u:int):auto =
    doAssert not vis[u]
    var rank:seq[tuple[u, r:int]]
    proc dfsImpl(v, r:int) =
      vis[v] = true
      rank.add (v, r)
      for (u, d) in adj[v]:
        if vis[u]: continue
        dfsImpl(u, r + d)
    dfsImpl(u, 0)
    var
      rank_min = int.inf
    for i in rank.len:
      rank_min.min=rank[i].r
    for i in rank.len:
      rank[i].r -= rank_min
    return rank
  var
    rank_bits, rank_maxs:seq[int]
    ranks:seq[seq[tuple[u, r:int]]]
  for u in N:
    if vis[u]: continue
    var
      rank = dfs(u)
      b = 0
      rank_max = -int.inf
    ranks.add rank
    for (u, r) in rank:
      b[r] = 1
      rank_max.max=r
    rank_bits.add b
    rank_maxs.add rank_max
  #debug ranks
  let L = rank_bits.len
  var ans = Seq[N: int]
  for i0 in L:
    var a:seq[int]
    # rank_bits[i0]の位置を先に決める
    # rank_maxs[i0] + t <= N - 1でなくてはならない
    for t in 0 .. N - 1 - rank_maxs[i0]:
      var dp = Seq[2^N: false]
      let b0 = rank_bits[i0] shl t
      dp[b0] = true
      for i in L:
        if i0 == i: continue
        var dp2 = Seq[2^N: false]
        for b in 2^N:
          if not dp[b]: continue
          for t in 0 .. N - 1 - rank_maxs[i]:
            let b2 = rank_bits[i] shl t
            if (b and b2) != 0: continue
            dp2[b or b2] = true
        dp = dp2.move
      if dp[2^N - 1]:
        a.add t
        if a.len >= 2: break
    #debug i0, a
    doAssert a.len > 0
    if a.len == 1:
      for (u, r) in ranks[i0]:
        ans[u] = r + a[0] + 1
    else:
      for (u, r) in ranks[i0]:
        ans[u] = -1
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, M, A, B, C)
else:
  discard

