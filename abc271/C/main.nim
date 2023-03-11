when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, a:seq[int]):
  s := a.toSet
  proc f(n:int):bool = # 1..nができるか
    ct := 0
    for i in 1 .. n:
      if i notin s:
        ct.inc
    if ct * 2 + n - ct <= N: return true
    return false
  echo f.maxRight(0..N+1)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  discard

