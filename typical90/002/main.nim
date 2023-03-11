const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils

solveProc solve(N:int):
  if N mod 2 == 1: return
  var v = Seq[string]
  for b in 2^N:
    var s = 0
    var valid = true
    var ans = ""
    for i in N:
      if b[i]: s.inc; ans &= "("
      else: s.dec; ans &= ")"
      if s < 0: valid = false;break
    if s != 0: valid = false
    if not valid: continue
    v.add ans
  v.sort
  echo v.join("\n")
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  solve(N)
#}}}

