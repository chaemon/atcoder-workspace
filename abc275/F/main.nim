when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N:int, M:int, a:seq[int]):
  var dp0, dp1 = Seq[M + 1: int.inf]
  # dp0[s]: 合計sで終了している
  # dp1[s]: 合計sで継続中
  dp0[0] = 0
  for i in N:
    # a[i]を足す
    var
      dp0_next = Seq[M + 1: int.inf]
      dp1_next = dp1
    for s in 0 .. M:
      # 消さずに使う
      if s + a[i] <= M:
        dp0_next[s + a[i]].min= dp0[s]
      # 新たに始める
      dp1_next[s].min= dp0[s] + 1
      # 終了させてもよい
      dp0_next[s].min= dp1_next[s]
    swap dp0, dp0_next
    swap dp1, dp1_next
  var ans = dp0[1..^1].mapIt(if it == int.inf: -1 else: it)
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, M, a)
else:
  discard

