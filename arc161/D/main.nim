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
solveProc solve(N:int, D:int):
  let DMAX = (N - 1) div 2
  if D > DMAX:
    echo NO;return
  else:
    echo YES
    for i in 1 .. D:
      for u in N:
        let v = (u + i) mod N
        echo u + 1, " ", v + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  solve(N, D)
else:
  discard

