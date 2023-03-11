when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, S:seq[string], T:seq[string]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, "")
  var T = newSeqWith(N, "")
  for i in 0..<N:
    S[i] = nextString()
    T[i] = nextString()
  solve(N, S, T)
else:
  discard

