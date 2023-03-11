const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, P:seq[int]):
  var
    P = P
    t = 1
    ans = Seq[int]
  for i in N:
    if i == N - 1:
      if P[t - 1] > P[t]:
        ans.add t - 1
        swap P[t - 1], P[t]
    else:
      # t - 1, t, t + 1の最大値をtに
      var M = max([P[t - 1], P[t], P[t + 1]])
      if M == P[t - 1]:
        ans.add t - 1
        swap P[t - 1], P[t]
      elif M == P[t]:
        discard
      else:
        ans.add t
        swap P[t], P[t + 1]
    t += 2
  for a in ans.mitems: a.inc
  echo ans.len
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(2*N, nextInt())
  solve(N, P)
else:
  discard

