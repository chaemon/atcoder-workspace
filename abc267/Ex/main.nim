when defined SecondCompile:
  const
    DO_CHECK = false
    DEBUG = false
else:
  const
    DO_CHECK = true
    DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
include lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/ntt
import lib/math/formal_power_series
#
#var x = initVar[mint](1)
#
#solveProc solve(N:int, M:int, A:seq[int]):
#  var d = initDeque[tuple[odd, even: FormalPowerSeries[mint]]]()
#  for i in N:
#    var
#      odd:FormalPowerSeries[mint] = x^A[i]
#      even:FormalPowerSeries[mint] = @[mint(1)]
#    if odd.len > M + 1: odd.resize(M + 1)
#    if even.len > M + 1: even.resize(M + 1)
#    d.addLast((odd, even))
#
#  while d.len > 1:
#    let (odd, even) = d.popFirst
#    let (odd2, even2) = d.popFirst
#    d.addLast((odd * even2 + odd2 * even, odd * odd2 + even * even2))
#  let (odd, even) = d.popFirst
#  if odd.len < M + 1:
#    echo 0
#  else:
#    echo odd[M]
#  echo "Hello World"
#  discard

solveProc solve(N:int, M:int, A:seq[int]):
  var ct = Seq[11: 0]
  for i in N: ct[A[i]].inc
  var even, odd: FormalPowerSeries[mint]
  even = @[mint(1)]
  odd = @[mint(0)]
  for i in 1 .. 10:
    var even1, odd1 = initFormalPowerSeries[mint](i * ct[i] + 1)
    for k in 0 .. ct[i]:
      if k mod 2 == 0:
        even1[i * k] += mint.C(ct[i], k)
      else:
        odd1[i * k] += mint.C(ct[i], k)
    var
      even_new = even * even1 + odd * odd1
      odd_new = even * odd1 + odd * even1
    even = even_new.move
    odd = odd_new.move
    if even.len >= M + 1: even.resize(M + 1)
    if odd.len >= M + 1: odd.resize(M + 1)
  if odd.len < M + 1:
    echo 0
  else:
    echo odd[M]
  discard


when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

