when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, a:seq[int], b:seq[int], c:seq[int]):
  Pred b
  var
    A = Seq[5000: seq[tuple[a, c:int]]]
  for i in N:
    A[b[i]].add (a[i], c[i])
  var
    dp = Seq[M + 1: int.inf]
  dp[0] = 0
  for b in A.len:
    if A[b].len == 0: continue
    var dp2 = dp
    for (a, c) in A[b]:
      for i in 0 .. M:
        if dp[i] == int.inf: continue
        dp2[min(i + c, M)].min=dp[i] + a
    dp = dp2.move
  echo if dp[M] == int.inf: -1 else: dp[M]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  var c = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
  solve(N, M, a, b, c)
else:
  discard

