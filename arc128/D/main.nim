const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/dp/cumulative_sum

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, A:seq[int]):
  proc calc(a:seq[int]):mint =
    var cs = initCumulativeSum[mint](a.len)
    cs[0] = 1
    cs[1] = 1
    prev := -1
    for i in 2 ..< a.len:
      # ends with a[i]
      var s:mint = 0
      if a[i - 2] == a[i]:
        if prev >= 0:
          s += cs[0 .. prev]
        s += cs[i - 2 .. i - 1]
      else:
        s += cs[0 ..< i]
        prev = i - 2
      cs[i] = s
    return cs[a.len - 1 .. a.len - 1]
  var
    B = A
    ans:mint = 1
  block:
    var i = 0
    while i < N:
      var j = i
      while j < N and B[i] == B[j]: j.inc
      if j - i > 1:
        for k in i..<j: B[k] = -1
      i = j
  block:
    var i = 0
    while i < N:
      j := i
      a := Seq[int]
      while j < N and B[j] != -1: a.add B[j]; j.inc
      if i > 0: a = A[i - 1] & a
      if j < N: a.add A[j]
      ans *= calc(a)
      i = j
      while i < N and B[i] == -1: i.inc
  echo ans
  Naive:
    var vis = initSet[seq[int]]()
    proc dfs(a:seq[int]) =
      if a in vis: return
      vis.incl a
      for i in 1 .. a.len - 2:
        if A[a[i - 1]] != A[a[i]] and A[a[i]] != A[a[i + 1]]:
          dfs(a[0 .. i - 1] & a[i + 1 ..< a.len])
    dfs((0..<N).toSeq)
    echo vis.len
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  import random
  for ct in 100:
    echo ct
    let N = 20
    var A = Seq[int]
    for i in N:
      A.add random.rand(1..N)
    test(N, A)
