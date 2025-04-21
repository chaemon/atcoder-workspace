when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:seq[int], V:seq[int]):
  var
    i = 0
    t = 0
    v = 0
  while true:
    # t -> t + 1
    if i < N and t == T[i]:
      v += V[i]
      i.inc
    if i == N:
      echo v;return
    if v > 0: v.dec
    t.inc
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, 0)
  var V = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    V[i] = nextInt()
  solve(N, T, V)
else:
  discard

