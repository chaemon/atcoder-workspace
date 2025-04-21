when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int):
  proc f(n:int):bool =
    # n * (n + 1) / 2 <= N
    return n * (n + 1) <= N * 2
  echo f.maxRight(1 .. 1500000000)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  discard

