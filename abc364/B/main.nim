when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, S_i:int, S_j:int, C:seq[string], X:string):
  Pred S_i, S_j
  var
    x = S_i
    y = S_j
  for i in X.len:
    var
      x2 = x
      y2 = y
    case X[i]:
      of 'L':
        y2.dec
      of 'R':
        y2.inc
      of 'U':
        x2.dec
      of 'D':
        x2.inc
      else:
        doAssert false
    if x2 in 0 ..< H and y2 in 0 ..< W and C[x2][y2] == '.':
      x = x2;y = y2
  echo x + 1, " ", y + 1
  doAssert false
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S_i = nextInt()
  var S_j = nextInt()
  var C = newSeqWith(H, nextString())
  var X = nextString()
  solve(H, W, S_i, S_j, C, X)
else:
  discard

