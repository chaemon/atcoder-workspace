include atcoder/extra/header/chaemon_header

const DEBUG = true
const DO_TEST = false

solveProc solve(N:int):
  let a = 108 * N div 100
  if a < 206:
    echo "Yay!"
  elif a > 206:
    echo ":("
  else:
    echo "so-so"
  return

when not DO_TEST:
# input part {{{
  var N = nextInt()
  solve(N, true)
#}}}

