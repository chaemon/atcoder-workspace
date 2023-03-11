const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

solveProc solve(N:int):
  var ans = 0
  var A = 1
  while true:
    if A * A * A > N: break
    var B = A
    while true:
      if A * B * B > N: break
      let p = N.floorDiv(A * B)
      doAssert B <= p
      ans += p - B + 1
      B.inc
    A.inc
  echo ans
  return

when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  discard

