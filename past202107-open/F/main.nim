const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(N:int, D:seq[int], S:seq[int], T:seq[int]):
  var a = Seq[10^5 + 1: newSeq[(int, int)]()]
  for i in N:
    a[D[i]].add((S[i], T[i]))
  for i in a.len:
    a[i].sort
    var p = -int.inf
    for (s, t) in a[i]:
      if s < p:
        echo YES;return
      p.max= t
  echo NO
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var D = newSeqWith(N, 0)
  var S = newSeqWith(N, 0)
  var T = newSeqWith(N, 0)
  for i in 0..<N:
    D[i] = nextInt()
    S[i] = nextInt()
    T[i] = nextInt()
  solve(N, D, S, T)
#}}}

