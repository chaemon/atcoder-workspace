when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H:int, W:int, C:seq[string]):
  var ans:seq[int]
  for j in W:
    c := 0
    for i in H:
      if C[i][j] == '#': c.inc
    ans.add c
  echo ans.join(" ")
  discard


when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var C = newSeqWith(H, nextString())
  solve(H, W, C)
else:
  discard

