const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve(S:string, T:string):
  let r = (T[0].ord - S[0].ord).floorMod(26)
  for i in S.len:
    let c = ((S[i].ord - 'a'.ord + r) mod 26 + 'a'.ord).chr
    if c != T[i]:
      echo NO;return
  echo YES
  return

when not DO_TEST:
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

