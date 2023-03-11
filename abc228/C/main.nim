const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, K:int, P:seq[seq[int]]):
  var a = Seq[int]
  for i in 0..<N: a.add P[i].sum
  a.sort
  for i in 0..<N:
    let s = P[i].sum + 300
    let t = N - a.upperBound(s) + 1
    if t <= K: echo YES
    else: echo NO
  return

when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, newSeqWith(3, nextInt()))
  solve(N, K, P)
else:
  discard

