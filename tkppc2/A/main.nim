const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(S:string, T:string):
  echo S & T
  return

# input part {{{
when not DO_TEST:
  var S = nextString()
  var T = nextString()
  solve(S, T)
#}}}

