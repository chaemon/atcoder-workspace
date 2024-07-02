when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/extra/math/eratosthenes

const YES = "Yes"
const NO = "No"
solveProc solve(Q:int, X:seq[int]):
  var es = initEratosthenes()
  for i in Q:
    if es.isPrime(X[i]):
      echo YES
    else:
      echo NO
  discard

when not defined(DO_TEST):
  var Q = nextInt()
  var X = newSeqWith(Q, nextInt())
  solve(Q, X)
else:
  discard

