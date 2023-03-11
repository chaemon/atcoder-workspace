const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, K:int, T:string):
  var T = T
  var K = K - 1
  for i in K..<T.len:
    if T[i] in 'a'..'z':
      T[i] = (T[i].ord - 'a'.ord + 'A'.ord).chr
    else:
      T[i] = (T[i].ord - 'A'.ord + 'a'.ord).chr
  echo T
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var K = nextInt()
  var T = nextString()
  solve(N, K, T, true)
#}}}

