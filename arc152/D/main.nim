when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(N: int, K: int):
  if N mod 2 == 0:
    echo -1; return
  let g = gcd(N, K)
  let M = (N - 1) /. 2
  echo M
  if g == 1:
    var u = 0
    for _ in M:
      echo u, " ", (u + K) mod N
      u += 2 * K
      u.mod = N
  else:
    # 成分がg個ある
    let n = N div g
    # 各成分はn個の頂点を持つ
    proc id(i, j: int): int =
      # i番目の成分のj個目の頂点
      (i + j * K) mod N
    var u = 0
    for _ in (n - 1) div 2:
      for i in g:
        let
          x = id(i, u)
          y = if i < g - 1: id(i + 1, u) else: id(0, u + 1)
        echo x, " ", y
      u += 2
      u.mod = n
    # この時点でid(i, u) (1 <= i)だけ辺がない
    block:
      i := 1
      for _ in (g - 1) div 2:
        let
          x = id(i, u)
          y = (id(i + 1, u) - K) %. N
        echo x, " ", y
        i += 2
  Check(strm):
    let t = strm.nextInt()
    if t == -1: return
    strm.setPosition(0)
    var dsu = initDSU(N)
    let M = strm.nextInt()
    doAssert N mod 2 == 1 and M == (N - 1) /. 2
    for _ in M:
      let u, v = strm.nextInt()
      doAssert u in 0 ..< N and v in 0 ..< N and u != v
      doAssert not dsu.same(u, v)
      dsu.merge(u, v)
      let
        u2 = (u + K) mod N
        v2 = (v + K) mod N
      doAssert not dsu.same(u2, v2)
      dsu.merge(u2, v2)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
else:
  for N in 1 .. 1000:
    for K in 1 .. N - 1:
      debug N, K
      test(N, K)
