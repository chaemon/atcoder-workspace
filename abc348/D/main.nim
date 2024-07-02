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
solveProc solve(H:int, W:int, A:seq[string], N:int, R:seq[int], C:seq[int], E:seq[int]):
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, nextString())
  var N = nextInt()
  var R = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var E = newSeqWith(N, 0)
  for i in 0..<N:
    R[i] = nextInt()
    C[i] = nextInt()
    E[i] = nextInt()
  solve(H, W, A, N, R, C, E)
else:
  discard

