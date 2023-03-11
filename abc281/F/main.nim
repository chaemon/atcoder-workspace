when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N: int, a: seq[int]):
  proc calcMin(d: int, a: seq[int]): int =
    if d == -1: return 0
    shadow a
    var zero, one: seq[int]
    for i in a.len:
      if a[i][d] == 0:
        zero.add a[i]
      else:
        a[i][d] = 0
        one.add a[i]
    if zero.len == 0:
      return calcMin(d - 1, one)
    elif one.len == 0:
      return calcMin(d - 1, zero)
    else:
      return min(calcMin(d - 1, one), calcMin(d - 1, zero)) + 2^d
  echo calcMin(29, a)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  discard

