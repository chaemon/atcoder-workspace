when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, Q:int, S:string, X:seq[int], C:seq[string]):
  var
    ct = 0
    S = S
  Pred X
  for i in N - 2:
    if S[i ..< i + 3] == "ABC": ct.inc
  for q in Q:
    let
      C = C[q][0]
      X = X[q]
    if S[X] == C:
      echo ct
      continue
    for i in X - 2 .. X:
      if i notin 0 ..< N - 2: continue
      if S[i ..< i + 3] == "ABC": ct.dec
    S[X] = C
    for i in X - 2 .. X:
      if i notin 0 ..< N - 2: continue
      if S[i ..< i + 3] == "ABC": ct.inc
    echo ct
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var S = nextString()
  var X = newSeqWith(Q, 0)
  var C = newSeqWith(Q, "")
  for i in 0..<Q:
    X[i] = nextInt()
    C[i] = nextString()
  solve(N, Q, S, X, C)
else:
  discard

