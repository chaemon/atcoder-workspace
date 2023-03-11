when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/string/rolling_hash

solveProc solve(N:int, T:string):
  var
    h = initRollingHash(T)
    revT = T
  revT.reverse
  var
    rh = initRollingHash(revT)
  for i in 0 .. N:
    let u = h.connect(h[0 ..< i].h, h[i + N ..< N * 2].h, N - i)
    # i ..< i + N
    if u == rh[2 * N - 1 - (i + N - 1) .. 2 * N - 1 - i]:
      echo T[0 ..< i] & T[i + N ..< N * 2]
      echo i
      return
  echo -1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextString()
  solve(N, T)
else:
  discard

