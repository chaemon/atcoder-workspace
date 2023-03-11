const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/convolution
import lib/math/combination

solveProc solve(N:int, K:int, c:seq[int]):
  var K = K
  if K > N:
    var K2 = N
    if K2 mod 2 != K mod 2: K2.inc
    swap K, K2
  var dp = Seq[N + 1: mint]
  dp[0] = 1
  dp[1] = 0
  for n in 2 .. N:
    dp[n] = (n - 1) * (dp[n - 1] + dp[n - 2])
  proc calc(n:int):seq[mint] =
    result = Seq[n + 1: mint(0)]
    for k in 0..n:
      if k == 1: continue
      if k == 2:
        result[1] = mint.C(n, k) * dp[k]
      else:
        result[k] = mint.C(n, k) * dp[k]
  var ct = initTable[int, int]()
  for c in c:
    if c notin ct: ct[c] = 0
    ct[c].inc
  var q = initDeque[seq[mint]]()
  for k, v in ct:
    q.addLast calc(v)
  debug q
  while q.len > 1:
    var a, b = q.popFirst
    q.addLast a.convolution(b)
  debug q
  var
    a = q.popFirst
    ans = mint(0)
  for i in a.len:
    if i mod 2 == K mod 2 and i <= K:
      debug i, a[i]
      ans += a[i]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var c = newSeqWith(N, nextInt())
  solve(N, K, c)
else:
  discard

