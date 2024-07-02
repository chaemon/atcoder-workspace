when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(S:string, T:string):
  proc calc_type(S:string):int =
    var S = S
    S.sort
    if S in ["AB", "BC", "CD", "DE", "AE"]:
      return 1
    else:
      return 2
  if calc_type(S) == calc_type(T):
    echo YES
  else:
    echo NO

when not defined(DO_TEST):
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

