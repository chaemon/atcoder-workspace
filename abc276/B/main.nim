when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  let
    A = A.pred
    B = B.pred
  var adj = Seq[N: seq[int]]
  for i in M:
    adj[A[i]].add B[i]
    adj[B[i]].add A[i]
  for i in N:
    adj[i].sort
    echo adj[i].len, " ", adj[i].succ.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

