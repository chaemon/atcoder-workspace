when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, l:seq[int], d:seq[int], k:seq[int], c:seq[int], A:seq[int], B:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var l = newSeqWith(M, 0)
  var d = newSeqWith(M, 0)
  var k = newSeqWith(M, 0)
  var c = newSeqWith(M, 0)
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    l[i] = nextInt()
    d[i] = nextInt()
    k[i] = nextInt()
    c[i] = nextInt()
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, l, d, k, c, A, B)
else:
  discard

