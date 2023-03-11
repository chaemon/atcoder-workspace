const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = true
include atcoder/extra/header/chaemon_header

import atcoder/extra/dp/longest_increasing_subsequence
import atcoder/extra/other/bitutils

const YES = "YES"
const NO = "NO"

solveProc solve(N:int, P:seq[int]):
  Naive:
    for b in 2^N:
      var v, w = Seq[int]
      for i in N:
        if b[i]: v.add(P[i])
        else: w.add(P[i])
      if v.longestIncreasingSubsequence == w.longestIncreasingSubsequence:
        echo YES;return
    echo NO
  discard

when DO_TEST:
#  let N = 10
#  var P = (0..<N).toSeq
#  while true:
#    if solve_naive(N, P) == NO & "\n":
#      echo P, P.longest_increasing_subsequence
#    else:
#      let l = P.longest_increasing_subsequence
#      if l mod 2 == 1:
#        echo "!!", P, " ", l
#    if not nextPermutation(P): break

  let P = @[1, 4, 5, 0, 7, 6, 3, 9, 8, 2]
  echo P.longest_increasing_subsequence

# Failed to predict input format
when not DO_TEST:
  let T = nextInt()
  for _ in T:
    let N = nextInt()
    let P = newSeqWith(N, nextInt() - 1)
    solve(N, P)
  discard

