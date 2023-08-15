const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int):
  var
    p = 1
    N = N
    ans:seq[int]
  while N != 0:
    if (N - 1) mod 3 == 0:
      N -= 1
      ans.add p
    elif (N + 1) mod 3 == 0:
      N += 1
      ans.add -p
    doAssert N mod 3 == 0
    N.div=3
    p *= 3
  echo ans.len
  echo ans.join(" ")
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  solve(N)
#}}}

