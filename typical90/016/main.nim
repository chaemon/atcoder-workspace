const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, A:int, B:int, C:int):
  var ans = int.inf
  for a in 0..9999:
    for b in 0..9999:
      let s = N - a * A - b * B
      if s >= 0 and s mod C == 0:
        let c = s div C
        ans.min=a + b + c
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = nextInt()
  solve(N, A, B, C)
#}}}

