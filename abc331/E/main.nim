when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, L:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var L = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(M, nextInt())
  var c = newSeqWith(L, 0)
  var d = newSeqWith(L, 0)
  for i in 0..<L:
    c[i] = nextInt()
    d[i] = nextInt()
  solve(N, M, L, a, b, c, d)
else:
  discard

