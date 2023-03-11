const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header


solveProc solve(S:string, K:int):
  var S = S
  S.sort
  var v = Seq[string]
  while true:
    v.add S
    if not S.nextPermutation: break
  echo v[K - 1]
  return

when not DO_TEST:
  var S = nextString()
  var K = nextInt()
  solve(S, K)
else:
  discard

