const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, S:seq[string], T:seq[int]):
  appeared := initSet[string]()
  original := Seq[int]
  original_max := -int.inf
  for i in N:
    if S[i] notin appeared:
      original.add i
      appeared.incl S[i]
      original_max.max= T[i]
  for i in original:
    if T[i] == original_max:
      echo i + 1
      return

when not DO_TEST:
  var N = nextInt()
  var S = newSeqWith(N, "")
  var T = newSeqWith(N, 0)
  for i in 0..<N:
    S[i] = nextString()
    T[i] = nextInt()
  solve(N, S, T)
else:
  discard

