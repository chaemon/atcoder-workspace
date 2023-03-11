const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, S:string):
  var S = S
  for i in S.len:
    if S[i] == 'x' and i in 1..S.len-2 and S[i - 1] == S[i + 1] and S[i - 1] in ['a','i','u','e','o']:
      for j in i - 1 .. i + 1:
        S[j] = '.'
  echo S
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}

