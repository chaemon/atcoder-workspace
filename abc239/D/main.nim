const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/math/eratosthenes

solveProc solve(A:int, B:int, C:int, D:int):
  var es = initEratosthenes()
  proc aoki_win(x:int):bool = 
    for y in C .. D:
      if es.isPrime(x + y): return true
    return false
  for t in A .. B:
    if not aoki_win(t):
      echo "Takahashi"; return
  echo "Aoki"
  discard

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  var D = nextInt()
  solve(A, B, C, D)
else:
  discard

