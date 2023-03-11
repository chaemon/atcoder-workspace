const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

converter toOptions[T](a:Option[T]):T = a.get
converter toOptions[T](a:T):Option[T] = a.some

solveProc solve(N:int, M:int, L:seq[int], R:seq[int]):
  dp := Seq[N + 1, N + 1: mint.none] # 区間l ..< rのインデックスを決める
  dp2 := Seq[N + 1, N + 1: mint.none] # dpのうちl ..< rから右にはみ出るものを除く
  proc calc(l, r:int):mint =
    if dp[l][r].isSome: return dp[l][r]
    if l == r: result = 1
    else:
      left := newSeq[int]()
      for i in M:
        if r <= R[i] and L[i] in l ..< r:
          left.add L[i]
      left = left.toSet().toSeq().sorted()
      result = mint(0)
      debug l, r, left
      if left.len == 0: result += calc(l, r - 1)
      else:
        if left[^1] < r - 1: result += calc(l, r - 1)
        for l0 in left:
          result += calc(l, l0) * calc(l0, r - 1)
    debug l, r, result
    dp[l][r] = result
  echo calc(0, N)
  Naive:
    #proc check(x:seq[int]) =
    #  for i in M:
    #    for j in i + 1 ..< M:
    #      l0 := max(L[i], L[j])
    #      r0 := min(R[i], R[j])
    #      if l0 >= r0: continue
    #      if x[i] in l0 ..< r0 and x[j] in l0 ..< r0:
    #        doAssert x[i] == x[j]
    a := (0..<N).toSeq
    ans := initSet[seq[int]]()
    while true:
      var x = Seq[M:int]
      for i in M:
        var
          m = -int.inf
          mi = -1
        for j in L[i] ..< R[i]:
          if m < a[j]:
            m = a[j]
            mi = j
        x[i] = mi
      ans.incl x
      if not a.nextPermutation: break
    #for x in ans:
    #  check x
    echo ans.len
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var L = newSeqWith(M, 0)
  var R = newSeqWith(M, 0)
  for i in 0..<M:
    L[i] = nextInt() - 1 # L[i] ..< R[i]
    R[i] = nextInt()
  #test(N, M, L, R)
  solve(N, M, L, R)
else:
  let N = 3
  for a in 0 ..< N:
    for b in a + 1 .. N:
      for c in 0 ..< N:
        for d in c + 1 .. N:
          let L = @[a, c]
          let R = @[b, d]
          debug N, 2, L, R
          test(N, 2, L, R)


