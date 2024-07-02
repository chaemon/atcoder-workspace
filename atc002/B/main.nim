when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, P:int):
  proc calc(P:int):int =
    if P == 0: return 1
    else:
      let
        r = P mod 2
        q = P div 2
      result = calc(q)
      result *= result
      result.mod=M
      if r == 1:
        result *= N
        result.mod=M
  echo calc(P)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = nextInt()
  solve(N, M, P)
else:
  discard

