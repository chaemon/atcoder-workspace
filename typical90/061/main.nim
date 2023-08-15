const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(Q:int, t:seq[int], x:seq[int]):
  var d = initDeque[int]()
  for i in Q:
    if t[i] == 1:
      d.addFirst x[i]
    elif t[i] == 2:
      d.addLast x[i]
    else:
      echo d[x[i] - 1]
  return

# input part {{{
when not DO_TEST:
  var Q = nextInt()
  var t = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    t[i] = nextInt()
    x[i] = nextInt()
  solve(Q, t, x)
#}}}

