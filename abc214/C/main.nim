const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header

solveProc solve(N:int, S:seq[int], T:seq[int]):
  var
    i = 0
    t = int.inf
    ans = Seq[N: int.inf]
  for _ in N * 2:
    t.min= T[i]
    ans[i].min= t
    t += S[i]
    i = if i + 1 == N: 0 else: i + 1
  echo ans.join("\n")
  return

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextInt())
  var T = newSeqWith(N, nextInt())
  solve(N, S, T)

