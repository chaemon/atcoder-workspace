const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int):
  var a:seq[int]
  block:
    var N = N
    for b in 2 .. N:
      if b * b > N: break
      while N mod b == 0:
        a.add b
        N = N div b
    if N > 1: a.add N
  if a.len == 1:
    echo 0
  else:
    echo (a.len - 1) div 2 + 1
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  solve(N)
#}}}

