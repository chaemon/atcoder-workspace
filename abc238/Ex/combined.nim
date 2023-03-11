import macros
macro Please(x): untyped = nnkStmtList.newTree()

Please use Nim-ACL
Please use Nim-ACL
Please use Nim-ACL



import macros;macro ImportExpand(s:untyped):untyped = parseStmt(staticExec("echo " & $s[2] & " | base64 -d | xzcat"))
const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/header/chaemon_header.nim
ImportExpand "src/lib/header/chaemon_header.nim" <=== "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"


# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/modint.nim
ImportExpand "src/atcoder/modint.nim" <=== "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"

const MOD = 998244353
type mint = modint998244353

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/math/combination.nim
ImportExpand "src/lib/math/combination.nim" <=== "/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM4AphAwddADuaCNQtYnSg9EGWFdSeZNhl/k2Dbud7qVSqsAPL4HE63fXNWZPhdDnNnY69wJE46D4HBqbBcQ9CMMCwQy8cf9NH4FgimxoxyLbzIQJ2vqnxOfv8bIy2mYaMLcg+ZekJFWUhRWrWPk0FWrKhCzzqH/vLYoMxb/IVx9z0hnMsI0ZpfoKAlaq4XSnotZPY1tFpFuJKFKwEM/ptMBer1QgMdykT9wQxDCYqO5kp1u+ptvGTj9xLab+oZHDv/3PkB1F2TKxrueY2pnB/a8pR3hfgB7GPGfa0i1MOmsQ/KMfYGkbK8BiLAGrgPmf2ZZR28VcAqnyVQCX065HMl0IdTdgoS0N8SJ4O3fdpK7AmlEB5l4BxdfebIqFLu8nqUA0r2zF2SrihkQku7dYxRNgINNUBfNomIL/eihfZVpfRvyZh9A01P+GXAgn6xLl19fYd+kVPEPOOj1LyedTc7q0Y74JOD0MaVJDpxsbJGfwhSQ/Kj8QfJxE3qICSLn1lK6dDeBd9oGgDlHQIv0wSHp9TwvhgLSTEqYfOBrZI9l6zaYO94r1hpXy9kXWy0EgmoyV0J5ni7wtTpdsDTfMFUSlRvKnnJb1gem78O+LxNF9k2DEb5vB8zZbr5iuw+tkmyCgiiu4KUuneyKUmycJwHd3Hlj6zy4Acbo2uPOcHEpKzTbAabKD/L6Z2NUu8DAQ2aUdBQPy0MDlIG61gfmXhTpAdtZUAtgUgtGqLavAITnl34EdX4NFaTs17laXrVoJVQTsJc3crPQR4CCVbqxMz5gWkn1U4WvNaz04EA1oB8nd81WNsEETu/6aFJPHYUsxTp35inC3XjmazUl9KnzFQVIN0B/pH1XeV4V8dw6eXYE5lognZNopakq4MEO5Z5It+DdJR8ODwKcYajROTZ0Egftjf51HLH56mT3eACrjD1GDyUoL+9f0Cm5zhufD7/OmFAtH8aWub93U+AZP/TXDuQHA4h4OKtm27M47aH/FS0i0mN8ijeD5a3q4mVagX9WzIIqFPglEGQunFBnyrIAAAAMpioRnb+1jqAAGjBuIUAAAiwMS0scRn+wIAAAAABFla"


var
  dp:array[305, array[305, (mint, mint)]]
  vis:array[305, array[305, bool]]

solveProc solve(N:int, S:string):
  vis.fill(false)
  proc calc(i, j:int):tuple[n, s:mint]
  proc succ(n:int):int = 
    var n = n + 1
    if n == N: n -= N
    return n
  proc pred(n:int):int =
    var n = n - 1
    if n == -1: n += N
    return n
  proc dist(i, j:int):int =
    if S[i] == 'L':
      result = i - j
      if result <= 0: result += N
    elif S[i] == 'R':
      result = j - i
      if result <= 0: result += N
  proc calc_range(i, j:int):tuple[n, s:mint] =
    doAssert S[i] != S[j]
    var (i, j) = (i, j)
    if S[i] == 'L': swap(i, j)
    result = (mint(0), mint(0))
    # iから時計回りにj
    var k = i.succ
    while true:
      # i ..< k
      # j ..< k.pred
      let
        d0 = dist(i, k) - 1
        d1 = dist(j, k.pred) - 1
        c = mint.C(d0 + d1, d0)
        (n0, s0) = calc(i, k)
        (n1, s1) = calc(j, k.pred)
      doAssert d0 >= 0 and d1 >= 0
      result.n += c * n0 * n1
      result.s += c * (s0 * n1 + n0 * s1)
      if k == j: break
      k = k.succ
  proc calc(i, j:int):tuple[n, s:mint] =
    # iからS[i]の方向へjの前まで
    # i = jのときは全部
    if vis[i][j]: return dp[i][j]
    vis[i][j] = true
    if S[i] == 'L':
      if i.pred == j: result = (mint(1), mint(0))
      else:
        result = (mint(0), mint(0))
        var k = i
        while true:
          k = k.pred
          if k == j: break
          doAssert i != k and k != j
          if S[k] == 'L':
            var
              d0 = dist(i, k) - 1
              d1 = dist(k, j) - 1
              c = mint.C(d0 + d1, d0)
              (n0, s0) = calc(i, k)
              (n1, s1) = calc(k, j)
            doAssert d0 >= 0 and d1 >= 0
            result.n += c * n0 * n1
            result.s += c * (s0 * n1 + n0 * s1 + dist(i, k) * n0 * n1)
          elif S[k] == 'R':
            if k.pred == j:
              let (n0, s0) = calc_range(i, k)
              result.n += n0
              result.s += s0 + dist(i, k) * n0
    elif S[i] == 'R':
      if i.succ == j: result = (mint(1), mint(0))
      else:
        result = (mint(0), mint(0))
        var k = i
        while true:
          k = k.succ
          if k == j: break
          doAssert i != k and k != j
          if S[k] == 'R':
            var
              d0 = dist(i, k) - 1
              d1 = dist(k, j) - 1
              c = mint.C(d0 + d1, d0)
              (n0, s0) = calc(i, k)
              (n1, s1) = calc(k, j)
            doAssert d0 >= 0 and d1 >= 0
            result.n += c * n0 * n1
            result.s += c * (s0 * n1 + n0 * s1 + dist(i, k) * n0 * n1)
          elif S[k] == 'L':
            if k.succ == j:
              let (n0, s0) = calc_range(i, k)
              result.n += n0
              result.s += s0 + dist(i, k) * n0
    dp[i][j] = result
  var
    n = mint(0)
    s = mint(0)
  for i in N:
    let (n0, s0) = calc(i, i)
    n += n0
    s += s0
  echo s / n
  Naive:
    proc succ(n:int):int = 
      var n = n + 1
      if n == N: n -= N
      return n
    proc pred(n:int):int =
      var n = n - 1
      if n == -1: n += N
      return n
    proc dist(i, j:int):int =
      if S[i] == 'L':
        result = i - j
        if result <= 0: result += N
      elif S[i] == 'R':
        result = j - i
        if result <= 0: result += N

    ans := mint(0)
    n := 0
    visited := Seq[N: false]
    proc f(c, s:int) =
      if c == N - 1:
        ans += s
        n.inc
        return
      for i in N:
        if visited[i]: continue
        # select i
        var j = i
        while true:
          if S[i] == 'L':
            j = j.pred
          else:
            j = j.succ
          if not visited[j]: break
        visited[j] = true
        f(c + 1, s + dist(i, j))
        visited[j] = false
    f(0, 0)
    echo ans / n

# see https://github.com/zer0-star/Nim-ACL/tree/master/src/atcoder/extra/other/bitutils.nim
ImportExpand "src/lib/other/bitutils.nim" <=== "/Td6WFoAAATm1rRGAgAhARwAAAAQz1jM4AglAvhdADuaCNQtYnSg9EGWFdHzgJ4ZEZO9/uQdsAvy/1hn08ebwP9aJ3kG8YLADWap5bVtZeXCH7fyLJwPvr+KNEIHopAci48dyyEFXnPS5KVWx1Vw7txQKw3DigABFXNpB+2BACGQIVo9pQFtH6j6NYUUl0Govv+6owFZ4XaKAj+pnxn1WsryhfBsDO5qUTQiOCk6Z7nhJmMPxsI8BIms4DUm3chwxA+x3zVUOYqkFtzG53hG2/MMYrBH83TdcfIIXRZWzJpkA2NIBU/UyXpeNPgzrTg4FCp92pN80gbA2ZMv41jawcrfNgKm7a1rAGWMeEM++tlXtzGNAvdsyXixNUHd/OWspgwajNrVpK7naO97+HGwZzgnCz0rYgvMu88ChT7elkumWA+pjgFQwzLv0gqGVMtSWBFAM+pp05kccrj4VyrS8Zyrm1Jgn6Q2CcVhAAMITnegKlgg79CpXraCcLftN/WncoagIjn3rOChlLUKwOVLeNvhBBzyTgAgs02ypITv+wrA4aaoYpEjZEZvZqBU6JOojo82tlHekbnFkwCPdxRa1xgKLBeK2qf1sx9fI5EU59Oil+MD0UTV4a4HBff5PNlXe/howm8SLflHCeFI5UZpfgrg4w4EQmYHMut5UFmJ983RXOz3AGn4cMyTwABxtZ8pCSgRnABQCadhn5hxCOApXXykKb/9VY8hNx64GUv1sc7lAntHB1fr+0KmIVG1IMEuIV2Wtmb3/GKLAbLzOnJuJyByuMIcj0adCrYq9e3/UAdK85QokcXhqa77Zaf/ILgR8PybIVM8aJr1kH4JkJVSNiwz2ySl6RY9HhWVeuJqyb1vb0A9GetuMVpCjzaxU02kYes3C7Mz4gNlL+6Yuy9lg9EH3mIp7bmTHZp3Yhn64isDEeSJWabNcGlIhcUXOzWhd5p4O1pIB7mtPPAyZGS6jo1SRB1v2/ao4S+xIe3MdnFxSPZnsVsRSSA7DRWiWc46swNgZjkmMht3szcBUa5E6pPPiZOgAAAAyme7WyXwucYAAZQGphAAAIGQxL6xxGf7AgAAAAAEWVo="


when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  solve(N, S)
else:
  proc test_all(N:int) =
    for b in 2^N:
      var S = ""
      for i in N:
        if b[i] == 0: S.add 'L'
        else: S.add 'R'
      debug "test for: ", N, S
      test(N, S)
  for N in 2..10:
    test_all(N)

