when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/other/bitutils

const B = 1024

solveProc solve(N:int, K:int, A:seq[int]):
  # Kの２進数表記を考える
  var
    dp = newSeq[int](B)
    ans = 0
  dp[0] = 1
  for i in 63:
    var
      dp2 = newSeq[int](B)
      s = 0
    if K[i] == 1:
      for r in B:
        if dp[r] == 0: continue
        for j in N:
          let r2 = r + A[j]
          s += r2 mod 2
          dp2[r2 div 2].inc
    else:
      for r in B:
        if dp[r] == 0: continue
        s += r mod 2
        dp2[r div 2].inc
      discard
    s.mod=2
    for r in B: dp2[r].mod=2
    if s == 1: ans[i] = 1
    dp = dp2.move
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

