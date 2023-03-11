include atcoder/extra/header/chaemon_header

const DEBUG = true
const DO_TEST = false


solveProc solve(N:int):
  var
    i = 1
    s = 0
  while true:
    s += i
    if s >= N:
      echo i;return
    i.inc
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  solve(N, true)
#}}}

