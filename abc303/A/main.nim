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
solveProc solve(N:int, S:string, T:string):
  proc is_similar(s, t:char):bool =
    if s == t: return true
    elif (s == 'l' and t == '1') or (s == '1' and t == 'l'):
      return true
    elif (s == 'o' and t == '0') or (s == '0' and t == 'o'):
      return true
    else:
      return false
  for i in N:
    if not isSimilar(S[i], T[i]): echo NO;return
  echo YES

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T)
else:
  discard

