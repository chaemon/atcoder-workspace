const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/modint, lib/math/combination
import lib/dp/longest_increasing_subsequence

solveProc solve(N:int, M:int, Q:int):
  type mint = DynamicModInt[-1]
  mint.setMod(Q)
  var ans = mint(0)
  block:
    var
      x = 2
      y = min(N div 2, M)
    if x > y: break
    ans += y - x + 1
  for t in 0 .. N - 1:
    let u = N - 1 - t
    s := t div 2 + u div 2
    # 3 .. s + 1
    var p = min(M, s + 1) - 3 + 1
    if p <= 0: continue
    ans += p
  for d in 2 .. N:
    for k in 0 .. d + 1:
      var p = N - d - k
      if p < 0 or p mod 2 == 1: continue
      p.div=2
      if k == 0 and p == 0:
        # all N - 1
        if N - 1 <= M:
          ans += 1
      else:
        let p0 = mint.C(d + 1, k) * mint.C(d + p, p)
        # l in d .. d + p (p + 1個)で
        # l - 1とlが現れる
        #for l in d .. d + p:
        #  if l - 1 < 2 or M < l: continue
        #  ans += p0
        var x, y:int # x .. y
        if d == 2: x = 3
        else: x = d
        y = min(M, d + p)
        let q = y - x + 1
        if q < 0: continue
        ans += q * p0
  echo ans
  Naive:
    var P = (1 .. N).toSeq
    var ans = initSet[seq[int]]()
    while true:
      var ok = true
      var A = Seq[int]
      for i in N:
        var P2 = P[0 ..< i] & P[i + 1 ..< N]
        let q = P2.longest_increasing_subsequence
        if q notin 2 .. M: ok = false
        A.add q
      if ok:
        ans.incl A
      if not P.nextPermutation: break
    echo ans.len mod Q
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  solve(N, M, Q)
  #test(N, M, Q)
else:
  let Q = 998244353
  for N in 3 .. 10:
    for M in 2 .. N - 1:
      debug N, M, Q
      test(N, M, 998244353)
  discard

