when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/modint
import atcoder/extra/math/combination

type mint = modint

solveProc solve(N:int, P:int):
  mint.setMod(P)
  var
    X = N div 2
    Y = (N * (N - 1)) div 2
    dp = Seq[X + 1, X + 1, X + 1, Y + 1:mint(0)] # P: 直前と同じ偶奇の距離の頂点の数, Q: 異なる偶奇, p: 直前の辺の数, M: 辺の数
  dp[1][0][1][0] = 1
  for s in 1 ..< N:
    for P in 1 .. X:
      let Q = s - P
      if Q notin 0 .. X: continue
      for p in 1 .. P:
        var
          tmp = dp[P][Q][p]
          tmax = min(X - Q, N - P - Q)
          tmp2 = Seq[Y + 1: mint(0)]
          tmp3 = Seq[Y + 1: mint(0)]
        for t in 1 .. tmax:
          for i in 0 .. Y:
            tmp2[i] = 0
            tmp3[i] = 0
          for M in 0 .. Y:
            # t個目を追加する
            # p個の頂点の少なくとも1つはつなぐ
            for k in 1 .. p:
              # k本の辺を追加
              if k + M > Y: continue
              tmp2[k + M] += mint.C(p, k) * tmp[M]
          # 既存のt-1個とつなげる
          for M in 0 .. Y:
            for l in 0 .. t - 1:
              if l + M > Y: continue
              tmp3[l + M] += mint.C(t - 1, l) * tmp2[M]
          # t個追加で終わり: tmp3を反映
          # N - P - Q個からt個選ぶ
          for M in 0 .. Y:
            if tmp3[M] == 0: continue
            dp[Q + t][P][t][M] += mint.C(N - P - Q, t) * tmp3[M]
          swap(tmp, tmp3)
  var ans:seq[mint]
  for M in N - 1 .. Y:
    var s = mint(0)
    for p in 1 .. X:
      s += dp[X][X][p][M]
    ans.add s
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var P = nextInt()
  solve(N, P)
else:
  discard

