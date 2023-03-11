const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/eratosthenes
import lib/other/bitutils

solveProc solve(N:int, P:seq[int]):
  var es = initEratosthenes()
  var ans = 0
  var v = initTable[(int, int), int]()
  for i in N:
    var ps, ps2 = Seq[int]
    for (p, e) in es.factor(i + 1):
      ps.add p
    for (p, e) in es.factor(P[i]):
      ps2.add p
    if ps.len == 0 or ps2.len == 0: continue
    for b in 1 ..< 2^ps.len:
      for b2 in 1 ..< 2^ps2.len:
        var
          c = 0
          p = 1
          p2 = 1
        for i in ps.len:
          if b[i]: c.inc;p *= ps[i]
        for i in ps2.len:
          if b2[i]: c.inc;p2 *= ps2[i]
        v[(p, p2)].inc
        if c mod 2 == 0:
          ans += v[(p, p2)]
        else:
          ans -= v[(p, p2)]
  echo ans
  Naive:
    var ans = 0
    for i in N:
      for j in i ..< N:
        if gcd(i + 1, j + 1) == 1: continue
        if gcd(P[i], P[j]) == 1: continue
        ans.inc
    echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  import random
  const N = 200000
  var P = (1..N).toSeq
  for _ in 10:
    solve(N, P)
    P.shuffle

