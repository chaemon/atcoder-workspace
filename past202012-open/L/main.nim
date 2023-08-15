when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header


#  6
#  ababaa
#  aba

proc solve(N:int, S:string, T:string):void =
  var dp = [N + 1, N + 1] @ int16.inf
  for i in 0 .. N:
    for j in i .. N:
      dp[i][j] = (j - i).int16
  for d in 1 .. N:
    for i in N:
      let j = i + d
      if j > N: break
      # i ..< jを考える -> dp[i][j]を決める
      var a = d + 1 @ int16.inf
      a[0] = 0
      for t in 0 .. 3:
        var a2 = d + 1 @ int16.inf
        # i ..< k
        for k in i .. j:
          if a[k - i] == int16.inf: continue
          for l in k .. j:
            # k ..< lを消せないときは飛ばす
            if t in 1 .. 2 and dp[k][l] != 0: continue
            a2[l - i].min=a[k - i] + dp[k][l]
        a = a2.move
        if t == 3:
          break
        # 作ったa2の最後にT[t]を追加
        for k in 1 .. d << 1:
          # i ..< i + k - 1
          if S[i + k - 1] != T[t]:
            a[k] = int16.inf
          else:
            a[k] = a[k - 1]
        a[0] = int16.inf
      dp[i][j].min= a[d]
  echo (N - dp[0][N]) div 3
  discard

proc main():void =
  var N = nextInt()
  var S = nextString()
  var T = nextString()
  solve(N, S, T);
  return

main()
