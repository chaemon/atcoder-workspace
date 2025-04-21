when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/dp/cumulative_sum

solveProc solve(N:int, X:int, P:seq[int]):
  var p = Seq[N + 1: 0.0] # p[n]: n個レアが入っている確率
  p[0] = 1.0
  for i in N:
    var
      q = Seq[N + 1: 0.0]
      P = P[i] / 100
    for n in 0 .. N:
      q[n] += p[n] * (1.0 - P)
    for n in 0 ..< N:
      q[n + 1] += p[n] * P
    p = q.move
  var f = Seq[X + 1: 0.0]
  for i in 1 .. X:
    f[i] = 1.0
    for j in 1 .. N:
      f[i] += f[max(i - j, 0)] * p[j]
    f[i] /= 1.0 - p[0]
  echo f[X]

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, X, P)
else:
  discard

