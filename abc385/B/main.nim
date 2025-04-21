when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, X:int, Y:int, S:seq[string], T:string):
  Pred X, Y
  var
    vis = Seq[H, W: false]
    C = 0
  for t in T:
    var
      X2 = X
      Y2 = Y
    case t
      of 'U':
        X2.dec
      of 'D':
        X2.inc
      of 'L':
        Y2.dec
      of 'R':
        Y2.inc
      else:
        doAssert false
    if X2 in 0 ..< H and Y2 in 0 ..< W and S[X2][Y2] != '#':
      X = X2;Y = Y2
    if not vis[X][Y] and S[X][Y] == '@':
      C.inc
      vis[X][Y] = true
  echo X + 1, " ", Y + 1, " ", C
  doAssert false
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var S = newSeqWith(H, nextString())
  var T = nextString()
  solve(H, W, X, Y, S, T)
else:
  discard

