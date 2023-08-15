when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, S:seq[string], A:seq[int]):
  var
    S = S
    A = A
    m = A.min
  while true:
    if A[0] == m:
      echo S.join("\n");return
    A = A[1 .. ^1] & A[0]
    S = S[1 .. ^1] & S[0]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, "")
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    S[i] = nextString()
    A[i] = nextInt()
  solve(N, S, A)
else:
  discard

