include atcoder/extra/header/chaemon_header

import atcoder/extra/other/binary_search
import atcoder/extra/dp/cumulative_sum

const DEBUG = true
const DO_TEST = false

dumpTree:
  proc test(N:int, Q:int, A:seq[int], X:seq[int]):bool {.discardable.}
  proc test(N:int, Q:int, A:seq[int], X:seq[int]):bool =
    let s = solve(N, Q, A, X)
    let t = solve_naive(N, Q, A, X)
    if s != t:
      doAssert false

solveProc solve(N:int, Q:int, A:seq[int], X:seq[int]):
  alt := newSeq[int](N)
  cs := initCumulativeSum(N, int)
  for i in 0..<N:
    if i >= 2: alt[i] = alt[i - 2] + A[i]
    else: alt[i] = A[i]
    cs[i] = A[i]
  for X in X:
    proc f(k:int):bool =
      let i = N - k
      let j = N - 2 * k + 1
      if j < 0: return false
      if j >= A.len: return true
      if X <= A[j]: return true
      return X - A[j] <= A[i] - X
    let k = f.maxRight(0..N)
    var ans = cs[N-k..<N]
    let j = N - 2 * k + 1
    if j - 2 >= 0: ans += alt[j - 2]
    echo ans
  Naive:
    for x in X:
      var
        A = A
        ans = 0
      for i in 0..<N:
        if i mod 2 == 0:
          ans += A.pop()
        else:
          var q = Seq[(int, int)]
          for j in A.len:
            let d = abs(A[j] - x)
            q.add((d, j))
          q.sort()
          let i = q[0][1]
          A.delete(i, i)
      echo ans
#  Check:
#    doAssert result == solve_naive(N, Q, A, X)
  return

when DO_TEST:
  import random
  for ct in 100000:
    let B = 10
    let N = 10
    var A = Seq[int]
    for i in 0..<N:
      A.add rand(1..B)
    A.sort
    let Q = 100
    var X = Seq[int]
    for i in 0..<Q:
      X.add rand(1..B)
    test(N, Q, A, X)
  let
    N = 10
    Q = 100
    A = @[3, 4, 5, 5, 5, 6, 6, 7, 7, 8]
    X = @[10, 6, 10, 7, 8, 5, 1, 10, 10, 8, 6, 4, 4, 9, 5, 5, 5, 9, 10, 3, 5, 4, 9, 7, 8, 9, 8, 3, 1, 2, 9, 9, 5, 1, 3, 10, 9, 5, 7, 10, 5, 2, 1, 5, 1, 3, 4, 6, 3, 10, 5, 3, 6, 8, 2, 9, 3, 9, 3, 9, 2, 10, 9, 4, 10, 5, 7, 3, 4, 1, 8, 8, 5, 6, 8, 5, 5, 1, 7, 7, 9, 6, 9, 3, 3, 10, 5, 6, 9, 3, 2, 10, 2, 8, 6, 7, 8, 9, 9, 8]
  test(N, Q, A, X)
else:
  var
    N = nextInt()
    Q = nextInt()
    A = newSeqWith(N, nextInt())
    X = newSeqWith(Q, nextInt())
  solve(N, Q, A, X, true)
