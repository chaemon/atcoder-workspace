const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

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

import lib/other/bitutils

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

