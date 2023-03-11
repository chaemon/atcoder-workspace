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
    ans = Seq[int]
  for p in 2..N:
    if es.isPrime(p): ans.add p
  echo ans.join(" ")
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

