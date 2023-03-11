const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/eratosthenes

const B = 10^6

solveProc solve(N:int):
  var
    es = initEratosthenes()
    prime_count:array[B, int]
    pc = 0
    ans = 0
  for i in 0 ..< B:
    if i^3 > N: break
    prime_count[i] = pc
    if i > 0 and es.isPrime(i):
      pc.inc
      prime_count[i] = pc
      let t = min(N div (i^3), i)
      if i == t:
        ans += prime_count[t] - 1
      else:
        ans += prime_count[t]
    prime_count[i] = pc
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

