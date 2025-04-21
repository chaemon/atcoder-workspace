when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int], Q:seq[int]):
  Pred P, Q
  var
    a, zekken = Seq[N: int]
  for i in N:
    zekken[i] = Q[i]
  for i in N:
    a[Q[i]] = zekken[P[i]]
  for i in N:
    a[i].inc
  echo a.join(" ")
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  var Q = newSeqWith(N, nextInt())
  solve(N, P, Q)
else:
  discard

