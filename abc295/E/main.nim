when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

solveProc solve(N:int, M:int, K:int, A:seq[int]):
  var z = 0
  for i in N:
    if A[i] == 0: z.inc
  proc calc(t:int):mint =
    # tのべきとM - tのべき
    var pow_t, pow_Mt = Seq[N + 1: mint]
    pow_t[0] = 1
    pow_Mt[0] = 1
    for i in 1 .. N:
      pow_t[i] = pow_t[i - 1] * t
      pow_Mt[i] = pow_Mt[i - 1] * (M - t)
    # t以下となる確率
    var
      a = 0 # 確定しているt以下の数
    for i in N:
      if A[i] != 0 and A[i] <= t: a.inc
    # z個からK個以上をt以下にする
    result = 0
    for c in K .. N:
      # c個をt以下, N - c個をtより大きく
      let d = c - a
      if d notin 0 .. z: continue
      # z個のうちd箇所がt以下
      result += mint.C(z, d) * pow_t[d] * pow_Mt[z - d]
  var a = Seq[mint]
  for t in 0 .. M:
    a.add calc(t)
  ans := mint(0)
  for t in 1 .. M:
    ans += (a[t] - a[t - 1]) * t
  ans *= mint.inv(M)^z
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, K, A)
else:
  discard

