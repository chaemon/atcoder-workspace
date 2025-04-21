when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, u:seq[int], v:seq[int], w:seq[int]):
  Pred u, v
  var adj = Seq[N, N: -1]
  for i in M:
    adj[u[i]][v[i]] = w[i]
    adj[v[i]][u[i]] = w[i]
  var
    a = (1 .. N - 2).toSeq
    ans = int.inf
    vis = Seq[N: false]
  proc f(u:int, s = 0) =
    vis[u] = true
    for v in N:
      if adj[u][v] == -1 or vis[v]: continue
      let s2 = s xor adj[u][v]
      if v == N - 1:
        ans.min=s2
      else:
        f(v, s2)
    vis[u] = false
  f(0)
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var w = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
    w[i] = nextInt()
  solve(N, M, u, v, w)
else:
  discard

