const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header
import lib/dp/longest_increasing_subsequence
import lib/other/algorithmutils

proc isSubSeq(x, a:seq[int]):bool =
  var i, j = 0
  while true:
    if i == x.len: return true
    if j == a.len: return false
    if x[i] == a[j]:
      i.inc
    j.inc

solveProc solve(N:int, K:int, A:seq[int]):
  if K == 1:
    echo (1..N).toSeq.reversed.join(" ")
    return
  var ans = Seq[int]
  var r = Seq[K:seq[int]]
  var l = 0
  # add between 1 ..< A[0] beginning with 0
  for t in 1 ..< A[0]:
    r[l].add t
    if l + 1 < K: l.inc
  for i in K - 1:
    # add between A[i] + 1 ..< A[i+1] starting with i + 1
    l.max= i + 1
    for t in A[i] + 1 ..< A[i + 1]:
      r[l].add t
      if l + 1 < K: l.inc
  # add between A[K - 1] + 1 ..< N
  r[K - 2] &= (A[K - 1] + 1 .. N).toSeq.reversed
  r[K - 1].sort(SortOrder.Descending)
  for i in K:
    ans.add A[i]
    for t in r[i]: ans.add t
#    ans &= r[i]
  echo ans.join(" ")
  Naive:
    for a in (1..N).toSeq.permutation:
      if isSubSeq(A, a):
        let l = longestIncreasingSubsequence(a)
        if l == A.len:
          echo a.join(" ")
          return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt())
  solve(N, K, A)
else:
  const N = 10
  for K in 2..5:
    for A in (1..N).toSeq().combination(K):
      debug N, K, A
      test(N, K, A)
  discard

