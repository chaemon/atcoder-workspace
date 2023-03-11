const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int):
  var a = 0
  proc f(b:int):int = a^3 + a^2 * b + a * b^2 + b^3
  proc g(b:int):bool =
    if f(b) >= N: return true
    else: return false
  var ans = int.inf
  while a <= 10^6:
    var b = g.minLeft(0..10^6 + 1)
    ans.min=f(b)
    a.inc
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

