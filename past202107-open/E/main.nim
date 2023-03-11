const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int):
  var d = N - 3^30
  if d < 0: echo -1;return
  var k = 0
  while d > 1:
    if d mod 3 != 0: echo -1;return
    d.div=3
    k.inc
  k = 30 - k
  if k notin 1..30:
    echo -1
  else:
    echo k
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  solve(N)
#}}}

