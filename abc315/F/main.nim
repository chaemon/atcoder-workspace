when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const B = 32

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  proc dist(i, j:int):float =
    hypot(float(X[i] - X[j]), float(Y[i] - Y[j]))
  var dp = [N, B] @ float.inf # index, 省略した数
  dp[0][0] = 0.0
  for u in N:
    for d in 1 .. B: # d - 1個飛ばす
      let v = u - d
      if v < 0: continue
      let dst = dist(u, v)
      for i in 0 ..< B:
        if dp[v][i].isInf: continue
        # vでi個飛ばした状態からd - 1個飛ばしてuに行く
        let j = i + d - 1
        if j >= B: continue
        dp[u][j].min=dp[v][i] + dst
  var ans = float.inf
  for C in 0 ..< B:
    if dp[N - 1][C].isInf: continue
    var p = if C == 0: 0.0 else: 2.0^(C - 1)
    ans.min=p + dp[N - 1][C]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
else:
  discard

