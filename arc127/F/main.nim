const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format

solveProc solve(A, B, V, M:int):
  debug A, B, V, M
  # 0 ..< M
  if A + B <= M:
    echo M; return
  # A + B > M >= B
  let
    q = M div A
    r = M mod A
  debug q, r
  # 0 ..< r でq + 1個
  # r ..< A でq個
  # range
  # i in 0 ..< M - Bで+Bが可能
  let d = B mod A
  proc calc(t:int):tuple[val, kmax:int] =
    # t, t + d, t + 2 * d, ... , t + k * d
    # M - B <= t + k * dとなるkを求める

    # t + k * d >= rとなる kの範囲はm個とする
    var t = t
    var
      kmax:int
      m:int
    if t < M - B + d:
      t.mod=d
      kmax = max(0, (M - B - t).ceilDiv d)
      if t + kmax * d >= A: kmax.dec
      doAssert t in 0 ..< A
      doAssert t + kmax * d in 0 ..< A
      debug kmax
      if r - t >= 0:
        var k0 = (r - t) .ceilDiv d
        m = kmax - k0 + 1
      else:
        m = kmax + 1
      #block:
      #  var ct = 0
      #  var i = t
      #  while i < A:
      #    debug i
      #    ct.inc
      #    if i in 0 ..< r:
      #      discard
      #      #ans += q + 1
      #    else:
      #      discard
      #      #ans += q
      #    if i + B >= M: break
      #    i += d
      #  debug kmax + 1, ct
      #  doAssert kmax + 1 == ct
    else:
      kmax = 0
      if t in 0 ..< r: m = 0
      else: m = 1
    return (m * q + (kmax + 1 - m) * (q + 1), kmax)
  var t = V mod A
  var ans = 0
#  t.mod= d
#  debug t
  let (val, kmax) = calc(t)
  ans += val
  block:
    var s = t
    # s + k * A <= M - 1なる最大のkでs -> s + k * A
    var k0 = (M - 1 - s).floorDiv A
    s = s + k0 * A
    s -= B
    if s < 0: break
    if s mod A == t + kmax * d: break
    k0 = (M - 1 - s).floorDiv A
    s = s + k0 * A
    s = M - 1 - s
    debug s
    ans += calc(s).val
  echo ans
  Naive:
    var vis = Seq[M:false]
    proc dfs(v:int) =
      if vis[v]: return
      vis[v] = true
      if v - A in 0..<M:dfs(v - A)
      if v + A in 0..<M:dfs(v + A)
      if v - B in 0..<M:dfs(v - B)
      if v + B in 0..<M:dfs(v + B)
    dfs(V)
    echo vis.count(true)
  discard

when not DO_TEST:
  let T = nextInt()
  for _ in T:
    var A, B, V, M = nextInt()
    M.inc # 0 ..< M
    solve(A, B, V, M)
else:
  const MAX = 10
  for A in 1..MAX:
    for B in A + 1..MAX:
      if gcd(A, B) != 1: continue
      for M in B..MAX:
        for V in 0..<M:
          test(A, B, V, M + 1)
  discard

