const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, S:string):
  var turn = 0
  for s in S:
    if s == '1':
      if turn == 0:
        echo "Takahashi"
      else:
        echo "Aoki"
      return
    turn = 1 - turn
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}

