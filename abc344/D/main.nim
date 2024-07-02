when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let
    T = nextString()
    N = nextInt()
  var
    dp = Seq[T.len + 1: int.inf]
  dp[0] = 0
  for _ in N:
    var dp2 = dp
    let
      A = nextInt()
      S = Seq[A: nextString()]
    for i in T.len:
      for j in S.len:
        if i + S[j].len <= T.len and T[i ..< i + S[j].len] == S[j]:
          dp2[i + S[j].len].min=dp[i] + 1
    dp = dp2.move
  echo if dp[T.len] == int.inf: -1 else: dp[T.len]
  discard

when not DO_TEST:
  solve()
else:
  discard

