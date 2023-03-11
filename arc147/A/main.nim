const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/structure/set_map

solveProc solve(N:int, A:seq[int]):
  var A = A.sorted.reversed
  var s = initDeque[int]()
  for i in N: s.addLast A[i]
  ans := 0
  while s.len >= 2:
    var
      a = s.popFirst
      b = s[^1]
    let r = a mod b
    ans.inc
    if r > 0:
      s.addLast(r)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

