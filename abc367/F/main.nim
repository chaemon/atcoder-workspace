when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, Q:int, A:seq[int], B:seq[int], l:seq[int], r:seq[int], L:seq[int], R:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  var l = newSeqWith(Q, 0)
  var r = newSeqWith(Q, 0)
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt()
    r[i] = nextInt()
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, Q, A, B, l, r, L, R)
else:
  discard

