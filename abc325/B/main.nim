when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, W:seq[int], X:seq[int]):
  ans := 0
  for h in 24: # 世界標準時でh時からh + 1時に会議
    s := 0
    for i in N:
      var h2 = (h + X[i]) mod 24
      if h2 in 9 .. 17:
        s += W[i]
    ans.max=s
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var W = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  for i in 0..<N:
    W[i] = nextInt()
    X[i] = nextInt()
  solve(N, W, X)
else:
  discard

