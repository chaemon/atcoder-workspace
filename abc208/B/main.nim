const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(P:int):
  const B = 14
  var f = Seq[B:int]
  f[0] = 1
  for i in 1..<B:
    f[i] = f[i - 1] * i
  var ans = 0
  var P = P
  for i in countdown(B - 1, 0):
    ans += P div f[i]
    P = P mod f[i]
  echo ans
  return

# input part {{{
when not DO_TEST:
  var P = nextInt()
  solve(P, true)
#}}}

