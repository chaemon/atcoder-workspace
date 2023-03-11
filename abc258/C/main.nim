const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


# Failed to predict input format
solveProc solve():
  let N, Q = nextInt()
  let S = nextString()
  var b = 0
  for i in Q:
    let t, x = nextInt()
    if t == 1:
      b += x
      if b >= N: b -= N
    else:
      var x = - b + x - 1
      if x < 0: x += N
      doAssert x in 0 ..< N
      echo S[x]
  discard

when not DO_TEST:
  solve()
else:
  discard

