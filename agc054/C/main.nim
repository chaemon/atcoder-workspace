const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/structure/set_map

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N, K:int, P:seq[int]):
  var
    ans = mint(1)
    st = initSortedSet[int](countable = true)
  for i in 0..<N:
    var it = st.lowerBound(P[i])
    let d = distance(it, st.end())
    if d == K:
      # dはK, K + 1, ..., N - P[i]にできる
      ans *= N - P[i] - K + 1
    st.insert(P[i])
  echo ans
  Naive:
    proc dist(a, b:seq[int]):int =
      var pos = Seq[N + 1:int]
      for i in 0 ..< N: pos[b[i]] = i
      for i in N:
        for j in i + 1 ..< N:
          let
            bi = pos[a[i]]
            bj = pos[a[j]]
          # i < j
          if bi > bj: result.inc
    proc is_ok(P:seq[int]):bool =
      for i in N:
        ct := 0
        for j in 0..<i:
          if P[j] > P[i]: ct.inc
        if ct > K: return false
      return true
    var ok_list:seq[seq[int]]
    block:
      var Q:seq[int]
      for i in 1..N:Q.add i
      while true:
        if is_ok(Q):
          ok_list.add Q
        if not Q.nextPermutation: break
    doAssert P in ok_list
    var ans = 0
    block:
      var Q:seq[int]
      for i in 1..N:Q.add i
      while true:
        var m = int.inf
        for O in ok_list:
          m.min=dist(O, Q)
        if dist(P, Q) == m:
          ans.inc
        if not Q.nextPermutation: break
    echo ans
  discard

when not DO_TEST:
  let N, K = nextInt()
  let P = Seq[N:nextInt()]
  solve(N, K, P)
else:
  echo "start_test"
  let N = 6
  for K in 1..N-1:
    var P:seq[int]
    for i in 1..N: P.add i
    while true:
      proc is_ok(P:seq[int]):bool =
        for i in N:
          ct := 0
          for j in 0..<i:
            if P[j] > P[i]: ct.inc
          if ct > K: return false
        return true
      if is_ok(P):
        test(N, K, P)
      if not P.nextPermutation: break
