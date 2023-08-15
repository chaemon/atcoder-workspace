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
solveProc solve(N:int, M:int, U:seq[int], V:seq[int]):
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var M = nextInt()
    var U = newSeqWith(M, 0)
    var V = newSeqWith(M, 0)
    for i in 0..<M:
      U[i] = nextInt()
      V[i] = nextInt()
    solve(N, M, U, V)
else:
  discard

