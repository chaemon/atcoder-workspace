when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, A:seq[int], S:string):
  var dp = Seq[3 + 1, 2^3: 0]
  dp[0][0] = 1
  for i in N:
    var dp2 = dp
    if S[i] == 'M':
      for b in 2^3:
        let b2 = b or [A[i]]
        dp2[1][b2] += dp[0][b]
    elif S[i] == 'E':
      for b in 2^3:
        let b2 = b or [A[i]]
        dp2[2][b2] += dp[1][b]
    elif S[i] == 'X':
      for b in 2^3:
        let b2 = b or [A[i]]
        dp2[3][b2] += dp[2][b]
    dp = dp2.move
  var ans = 0
  for b in 2^3:
    var mex = 3
    for i in 3:
      if b[i] == 0:
        mex = i
        break
    ans += mex * dp[3][b]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var S = nextString()
  solve(N, A, S)
else:
  discard

