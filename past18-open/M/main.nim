when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/other/bitutils
import lib/math/zeta_transform

solveProc solve(N:int, M:int, S:int, A:seq[int], X:seq[int], Y:seq[int]):
  Pred X, Y
  var a = Seq[2^N: 0]
  for b in 2^N:
    s := 0
    for i in N:
      if b[i] == 1: s += A[i]
    if s > S: continue
    ok := true
    for i in M:
      if b[X[i]] == 1 and b[Y[i]] == 1: ok = false
    if ok: a[b] = 1
  var
    k = 0
    t = Seq[2^N: 0]
    az = zeta_subset(a)
  t[0] = 1
  while true:
    k.inc
    var
      tz = zeta_subset(t)
    for i in tz.len:tz[i] *= az[i]
    t = movius_subset(tz)
    for i in 2^N:
      if t[i] > 0: t[i] = 1
    if t[^1] == 1:
      echo k;return
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, nextInt())
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, M, S, A, X, Y)
else:
  discard

