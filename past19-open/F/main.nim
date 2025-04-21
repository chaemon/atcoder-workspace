when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, X:string, Y:string, S:seq[string], T:seq[string]):
  var
    vis = initSet[string]()
    adj = initTable[string, seq[string]]()
  for i in N:
    if S[i] notin adj:
      adj[S[i]] = newSeq[string]()
    adj[S[i]].add T[i]
  proc dfs(s:string) =
    if s in vis: return
    vis.incl s
    for t in adj[s]:
      dfs(t)
  dfs(X)
  if Y in vis:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextString()
  var Y = nextString()
  var S = newSeqWith(N, "")
  var T = newSeqWith(N, "")
  for i in 0..<N:
    S[i] = nextString()
    T[i] = nextString()
  solve(N, X, Y, S, T)
else:
  discard

