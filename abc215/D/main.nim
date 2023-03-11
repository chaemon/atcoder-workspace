const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import lib/math/eratosthenes


solveProc solve(N:int, M:int, A:seq[int]):
  var es = initEratosthenes()
  var s = initSet[int]()
  for a in A:
    for (p, _) in es.factor(a):
      s.incl p
  var ans = Seq[int]
  for k in 1..M:
    var valid = true
    for (p, _) in es.factor(k):
      if p in s: valid = false
    if valid:
      ans.add k
  echo ans.len
  echo ans.join("\n")
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

