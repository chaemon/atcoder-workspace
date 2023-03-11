when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(H: int, W: int, S: seq[string]):
  ans := 0
  for s in S:
    ans += s.count('#')
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
else:
  discard

