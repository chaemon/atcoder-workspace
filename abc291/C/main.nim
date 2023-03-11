when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, S:string):
  var
    hist = initSet[(int, int)]()
    x = 0
    y = 0
  hist.incl((x, y))
  for s in S:
    case s:
      of 'R': x.inc
      of 'L': x.dec
      of 'U': y.inc
      of 'D': y.dec
      else: doAssert false
    if (x, y) in hist: echo YES;return
  echo NO;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  discard

