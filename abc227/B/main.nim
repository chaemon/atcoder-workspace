const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(N:int, S:seq[int]):
  var s = initSet[int]()
  for a in 1..1000:
    for b in 1..1000:
      s.incl 4*a*b+3*a+3*b
  var ans = 0
  for a in S:
    if a notin s:
      ans.inc
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, nextInt())
  solve(N, S)
else:
  discard

