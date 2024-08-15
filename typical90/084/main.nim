const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



solveProc solve(N:int, S:string):
  var
    i = 0
    ans = (S.len * (S.len + 1)) div 2
  while i < S.len:
    var j = i + 1
    while j < S.len and S[i] == S[j]:
      j.inc
    let k = j - i
    ans -= (k * (k + 1)) div 2
    i = j
  echo ans
  doAssert false
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var S = nextString()
  solve(N, S)
#}}}

