when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N: int, K: int, C: int):
  echo N, " ", K, " ", C
  var dp = Seq[N + 1: mint(0)]
  for i in 0 ..< N:
    # i•¶Žš–Ú‚ðŒˆ‚ß‚é

    discard
  discard

import streams

proc solve_with_input(f:auto = stdin) =
  when f is string:
    var f = newStringStream(f)
  elif f is StringStream:
    f.setPosition(0)
  var N = f.nextInt()
  var K = f.nextInt()
  var C = f.nextInt()
  solve(N, K, C)


when not defined(DO_TEST):
  #solve_with_input()
  #solve_with_input("3 4 5")
  var strm = newStringStream("")
  strm.writeLine("3 4 5")
  solve_with_input(strm)
else:
  discard
