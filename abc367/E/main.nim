when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, X:seq[int], A:seq[int]):
  Pred X
  # B[i] = A[X[i]]
  # i -> X[i]
  var
    a: seq[seq[int]]
    vis = Seq[N: false]
  for u in N:
    if vis[u]: continue
    var
      v = u
      p:seq[int]
    while true:
      debug v, u
      vis[v] = true
      p.add v
      v = X[v]
      if v == u: break
    a.add p
  debug a
  var B = Seq[N: 0]
  for p in a:
    let r = K mod p.len
    for i in p.len:
      B[p[i]] = A[p[(i + r) mod p.len]]
  for i in N: B[i].inc
  echo B.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var X = newSeqWith(N, nextInt())
  var A = newSeqWith(N, nextInt())
  solve(N, K, X, A)
else:
  discard

