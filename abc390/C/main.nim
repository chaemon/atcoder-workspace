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
solveProc solve(H:int, W:int, S:seq[string]):
  var
    imin, jmin = int.inf
    imax, jmax = -int.inf
  for i in H:
    for j in W:
      if S[i][j] == '#':
        imin.min=i
        jmin.min=j
        imax.max=i
        jmax.max=j
  for i in H:
    for j in W:
      if i in imin..imax and j in jmin..jmax and S[i][j] == '.':
        echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

