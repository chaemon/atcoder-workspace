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
solveProc solve(K:int, S:string, T:string):
  const B = 20
  var dp = Seq[S.len + 1, B * 2 + 1: -1]
  # -B .. B
  proc calc(i, j:int):int =
    let d = i - j
    if abs(d) > K or j > T.len: return int.inf
    #debug i, j, d, d + B
    if dp[i][d + B] != -1: return dp[i][d + B]
    result = int.inf
    if i == 0:
      result = j
    elif j == 0:
      result = i
    elif S[i - 1] == T[j - 1]:
      result.min=calc(i - 1, j - 1)
    else:
      result.min=calc(i - 1, j - 1) + 1
      result.min=calc(i - 1, j) + 1
      result.min=calc(i, j - 1) + 1
    dp[i][d + B] = result
  echo if calc(S.len, T.len) <= K: YES else: NO

when not defined(DO_TEST):
  var K = nextInt()
  var S = nextString()
  var T = nextString()
  solve(K, S, T)
else:
  discard

