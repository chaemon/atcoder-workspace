include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils

const DEBUG = true

solveProc solve(N:int, M:int, S:seq[string]):
  var odd, even = 0
  for i in 0..<N:
    if S[i].count('1') mod 2 == 0: even.inc
    else: odd.inc
  echo odd * even
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, M, S)
#}}}

