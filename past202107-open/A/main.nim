const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(S:string):
  s := 0
  for i,d in S:
    let t = i + 1
    if t == 15:
      s.mod= 10
      if s == ($d).parseInt:
        echo YES
      else:
        echo NO
    else:
      if t mod 2 == 1: s += ($d).parseInt * 3
      else: s += ($d).parseInt
  return

# input part {{{
when not DO_TEST:
  var S = nextString()
  solve(S)
#}}}

