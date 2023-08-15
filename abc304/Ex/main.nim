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
solveProc solve(N:int, M:int, s:seq[int], t:seq[int], L:seq[int], R:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var s = newSeqWith(M, 0)
  var t = newSeqWith(M, 0)
  for i in 0..<M:
    s[i] = nextInt()
    t[i] = nextInt()
  var L = newSeqWith(N, 0)
  var R = newSeqWith(N, 0)
  for i in 0..<N:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, M, s, t, L, R)
else:
  discard

