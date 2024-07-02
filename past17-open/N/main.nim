when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, T:seq[int]):
  S := T.sum
  var dp = Seq[2^N: float.inf]
  dp[0] = 0.0
  for b in 0 ..< 2^N - 1:
    var
      t0 = 0
      k = 1
    for i in N:
      if b[i] == 1:
        t0 += T[i]
        k += 1
    for i in N:
      if b[i] == 1: continue
      # t = t0 〜 t0 + T[i]について|f(t)-S|を求める
      let a = float(N) / (float(k) - 0.5)
      proc calc(t:int):float =
        a * float(t) - float(S)
      proc calcIntegral(t:int or float):float =
        let t = float(t)
        return a * t^2 * 0.5 - float(S) * t
      let
        l = calc(t0)
        r = calc(t0 + T[i])
      var d:float
      if r <= 0.0:
        # 全部負
        # - a * t + S
        d = - (calcIntegral(t0 + T[i]) - calcIntegral(t0))
        discard
      elif 0.0 <= l:
        # 全部正
        d = (calcIntegral(t0 + T[i]) - calcIntegral(t0))
        discard
      if calc(t0) < 0.0 and 0.0 < calc(t0 + T[i]):
        # 負→正
        # a * t1 - S = 0の
        let t1 = float(S) / a
        d = - (calcIntegral(t1) - calcIntegral(t0))
        d += (calcIntegral(t0 + T[i]) - calcIntegral(t1))
        discard
      dp[b or [i]].min=dp[b] + d
  echo dp[2^N - 1] / float(S)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, nextInt())
  solve(N, T)
else:
  discard

