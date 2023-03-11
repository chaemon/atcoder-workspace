const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/eratosthenes

solveProc solve(N:int):
  var
    es = initEratosthenes()
    a = initTable[seq[int], int]()
    ans = 0
  for i in 1 .. N:
    var
      f = es.factor(i)
      v = Seq[int]
    for (p, e) in f:
      if e mod 2 == 1:
        v.add p
    v.sort
    ans += a[v]
    a[v].inc
  echo ans * 2 + N
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

