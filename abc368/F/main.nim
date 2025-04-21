when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/math/eratosthenes

solveProc solve(N:int, A:seq[int]):
  var e = initEratosthenes()
  var dp = Seq[10^5 + 1: -1]
  proc calc(n:int):int =
    if dp[n] >= 0: return dp[n]
    var v:seq[int]
    for d in e.divisor(n):
      if d == n: continue
      v.add calc(d)
    v.sort
    v = v.deduplicate(isSorted = true)
    result = -1
    for i in v.len:
      if v[i] != i: result = i;break
    if result == -1:
      result = v.len
    dp[n] = result
  var s = 0
  for i in N:
    s.xor= calc(A[i])
  if s == 0:
    echo "Bruno"
  else:
    echo "Anna"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

