when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var dp = Seq[N, N: -1]
  proc calc(i, j:int):int =
    if dp[i][j] != -1: return dp[i][j]
    if i == N - 1:
      result = A[j]
    else:
      let
        l = calc(i + 1, j)
        r = calc(i + 1, j + 1)
      if i mod 2 == 0:# taro
        if l <= r: result = r
        else: result = l
      else:
        if l >= r: result = r
        else: result = l
    dp[i][j] = result
  echo calc(0, 0)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

