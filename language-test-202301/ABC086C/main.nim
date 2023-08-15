when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, t:seq[int], x:seq[int], y:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var t = newSeqWith(N, 0)
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    t[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, t, x, y)
else:
  discard

