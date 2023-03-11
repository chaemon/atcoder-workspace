include atcoder/extra/header/chaemon_header

const DEBUG = true
const DO_TEST = false

import hashes

proc hash(x:int): Hash =
  return x

solveProc solve(N:int, A:seq[int]):
  var ans = N * (N - 1) div 2
  var tb = initTable[int, int]()
  for a in A:
    if a notin tb: tb[a] = 0
    tb[a].inc
  for k, v in tb: ans -= v * (v - 1) div 2

#  var A = A
#  A.sort
#  var i = 0
#  while i < N:
#    var j = i
#    while j < N and A[i] == A[j]: j.inc
#    let d = j - i
#    ans -= d * (d - 1) div 2
#    i = j
  echo ans
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A, true)
#}}}

