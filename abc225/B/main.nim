const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(N:int, a:seq[int], b:seq[int]):
  var d = newSeq[int](N)
  for i in 0..<N-1:
    d[a[i]].inc
    d[b[i]].inc
  for u in N:
    if d[u] == N - 1: echo YES;return
  echo NO
  return

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N-1, 0)
  var b = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
else:
  discard

