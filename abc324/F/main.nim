when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search_float

solveProc solve(N:int, M:int, u:seq[int], v:seq[int], b:seq[int], c:seq[int]):
  Pred u, v
  var adj = Seq[N: seq[tuple[v, b, c:int]]]
  for i in M:
    adj[u[i]].add (v[i], b[i], c[i])
  proc f(k:float):bool =
    # Σb[i] / Σc[i] >= kにできるか？
    # つまりb[i] - k * c[i]を0以上にできるかのmax_right
    # k = 10^5なら全部負になるから無理
    var dp = Seq[N: -float.inf]
    dp[0] = 0.0
    for u in N:
      if (-dp[u]).isInf: continue
      for (v, b, c) in adj[u]:
        dp[v].max=dp[u] + b - k * c
    return dp[^1] >= 0.0
  echo f.maxRight(0.0 .. 100000.0)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
  solve(N, M, u, v, b, c)
else:
  discard

