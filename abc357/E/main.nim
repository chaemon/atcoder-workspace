when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/scc

solveProc solve(N:int, a:seq[int]):
  Pred a
  var
    scc = initSccGraph(N)
    belongs = Seq[N: int]
  for i in N:
    debug i, a[i]
    scc.add_edge(i, a[i])
  var v = scc.scc()
  for i, g in v:
    for a in g:
      belongs[a] = i
  echo v
  var dp = Seq[v.len: 0]
  for i in 0 ..< v.len << 1:
    dp[i] += v[i].len
    var s = initSet[int]()
    for t in v[i]:
      # t -> a[t]
      if t != a[t]:
        s.incl belongs[a[t]]
    for t in s:
      dp[i] += dp[t]
  debug dp
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  discard

