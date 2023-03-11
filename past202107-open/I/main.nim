const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, x:seq[int], y:seq[int], a:seq[int], b:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var x = newSeqWith(2, 0)
  var y = newSeqWith(2, 0)
  for i in 0..<2:
    x[i] = nextInt()
    y[i] = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
  solve(N, x, y, a, b)
#}}}

