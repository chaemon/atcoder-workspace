when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, C:int, A:seq[int], u:seq[int], v:seq[int], c:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var C = nextInt()
  var A = newSeqWith(C, nextInt())
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
    c[i] = nextInt()
  solve(N, M, C, A, u, v, c)
else:
  discard

