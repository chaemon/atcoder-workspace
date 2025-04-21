when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, X:int, T:seq[int]):
  var dp = Seq[N + 1: initTable[int, int]()] # 注文iより前を出荷済。dp[i]は次の出荷日 => 不満度
  dp[0][0] = 0
  for i in N:
    for t, a in dp[i]:
      s := 0
      for k in 1 .. K:
        # k個を出荷する
        # 出荷は
        if i + k > N: break
        s += T[i + k - 1]
        var p = max(T[i + k - 1], t)
        let a2 = a + p * k - s
        if p + X notin dp[i + k]:
          dp[i + k][p + X] = a2
        else:
          dp[i + k][p + X].min=a2
  ans := int.inf
  for t, a in dp[N]:
    ans.min=a
  echo ans
  doAssert false
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var X = nextInt()
  var T = newSeqWith(N, nextInt())
  solve(N, K, X, T)
else:
  discard

