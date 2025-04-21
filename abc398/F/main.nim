when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/string/rolling_hash

solveProc solve(S:string):
  var
    h = initRollingHash(S)
  var
    Srev = S
  Srev.reverse
  var h_rev = initRollingHash(Srev)
  for t in 0 ..< S.len:
    # Sの最初のt文字
    if h[t ..< S.len] == h_rev[0 ..< S.len - t]:
      echo S & Srev[S.len - t ..< S.len]
      break
  doAssert false

when not defined(DO_TEST):
  var S = nextString()
  solve(S)
else:
  discard

