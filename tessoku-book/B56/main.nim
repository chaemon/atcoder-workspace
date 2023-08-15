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
solveProc solve(N:int, Q:int, S:string, L:seq[int], R:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var S = nextString()
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, Q, S, L, R)
else:
  discard

