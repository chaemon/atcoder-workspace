when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int]):
  Pred P
  if P == (0 ..< N).toSeq:
    echo 0
  elif P[0] == N - 1 and P[N - 1] == 0:
    echo 3
  else:
    var
      M = -1
    for i in N:
      if P[i] == i and M == i - 1:
        echo 1;return
      M.max=P[i]
    echo 2
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var P = newSeqWith(N, nextInt())
    solve(N, P)
else:
  discard

