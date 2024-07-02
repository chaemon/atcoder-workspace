when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(H:int, W:int, N:int, T:string, S:seq[string]):
  ans := 0
  for x in H:
    for y in W:
      var
        (x, y) = (x, y)
        ok = true
      if S[x][y] == '#':
        ok = false
      else:
        for i in N:
          case T[i]:
            of 'L':
              y.dec
            of 'R':
              y.inc
            of 'U':
              x.dec
            of 'D':
              x.inc
            else:
              doAssert false
          if S[x][y] == '#': ok = false;break
      if ok: ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var T = nextString()
  var S = newSeqWith(H, nextString())
  solve(H, W, N, T, S)
else:
  discard

