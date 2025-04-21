when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, X:seq[int], A:seq[int]):
  Pred X
  var
    pool = 0
    ans = 0
    
  for i in N:


    ans += pool
  if 
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var X = newSeqWith(M, nextInt())
  var A = newSeqWith(M, nextInt())
  solve(N, M, X, A)
else:
  discard

