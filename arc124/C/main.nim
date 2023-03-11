const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header



solveProc solve(N:int, a:seq[int], b:seq[int]):
  return

when not DO_TEST:
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, a, b)

