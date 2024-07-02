when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/warshall_floyd
import lib/other/bitutils

const NO = "No"
solveProc solve(N:int, M:int, U:seq[int], V:seq[int], W:seq[int]):
  Pred U, V
  var
    dp = Seq[2^N, N: int.inf]
    dist = Seq[N, N: int.inf]
  #for u in N: dist[u][u] = 0
  for i in M:
    dist[U[i]][V[i]] = W[i]
  var wf = warshallFloyd(dist)
  for b in 1 ..< 2^N:
    v := Seq[int]
    for u in N:
      if b[u] == 1:
        v.add u
    if v.len == 1:
      dp[b][v[0]] = 0
    else:
      # dp[b][u]を決める
      for u in v:
        doAssert b[u] == 1
        let b2 = b xor [u]
        for u2 in v:
          if u == u2: continue
          doAssert b2[u2] == 1
          let d = wf[u2, u]
          if dp[b2][u2] == int.inf or d == int.inf: continue
          dp[b][u].min= dp[b2][u2] + wf[u2, u]
  var ans = int.inf
  for u in N:
    ans.min=dp[(1 shl N) - 1][u]
  if ans == int.inf:
    echo No
  else:
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var U = newSeqWith(M, 0)
  var V = newSeqWith(M, 0)
  var W = newSeqWith(M, 0)
  for i in 0..<M:
    U[i] = nextInt()
    V[i] = nextInt()
    W[i] = nextInt()
  solve(N, M, U, V, W)
else:
  discard

