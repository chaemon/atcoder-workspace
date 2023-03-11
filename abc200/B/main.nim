include atcoder/extra/header/chaemon_header

import BigNum

const DEBUG = true

proc solve(N:int, K:int) =
  var N = newInt(N)
  var K = K
  while true:
    if K == 0:
      echo N;return
    elif N mod 200 == newInt(0):
      N = N div 200
    else:
      N = N * 1000 + 200
    K.dec
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  solve(N, K)
#}}}

