when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(W:int, H:int, N:int, p:seq[int], q:seq[int], A:int, a:seq[int], B:int, b:seq[int]):
  discard

when not defined(DO_TEST):
  var W = nextInt()
  var H = nextInt()
  var N = nextInt()
  var p = newSeqWith(N, 0)
  var q = newSeqWith(N, 0)
  for i in 0..<N:
    p[i] = nextInt()
    q[i] = nextInt()
  var A = nextInt()
  var a = newSeqWith(A, nextInt())
  var B = nextInt()
  var b = newSeqWith(B, nextInt())
  solve(W, H, N, p, q, A, a, B, b)
else:
  discard

