when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int):
  var d = block:
    var
      N = N
      d: seq[int]
    while N > 0:
      d.add N mod 10
      N.div=10
    d
  d.reverse
  proc calc(M:int):int = # mod mで考える
    var
      dp = Seq[M, M + 1, 2: 0] # 余り, 桁和, [0: 追従なし, 1: 追従]
      p = block:
        var
          p:seq[int]
          x = 1
        for i in d.len:
          p.add x
          x *= 10
          x.mod=M
        p.reverse
        p

    dp[0][0][1] = 1
    for i in d.len:
      var dp2 = Seq[M, M + 1, 2: 0] # 余り, 桁和, [0: 追従なし, 1: 追従]
      # 追従なしからの遷移
      # i桁目を0〜9に
      for r in M:
        for m in 0 .. M: # 桁和m
          for t in 0 .. 9:
            if m + t <= M:
              let r2 = (r + t * p[i]) mod M
              dp2[r2][m + t][0] += dp[r][m][0]

      # 追従から
      for r in M:
        for m in 0 .. M: # 桁和m
          # 追従を継続
          block:
            let t = d[i]
            if m + t <= M:
              dp2[(r + t * p[i]) mod M][m + t][1] += dp[r][m][1]
          # 追従を外れる
          for t in 0 ..< d[i]:
            if m + t <= M:
              let r2 = (r + t * p[i]) mod M
              dp2[r2][m + t][0] += dp[r][m][1]
      dp = dp2.move
    return dp[0][M][0] + dp[0][M][1]
  ans := 0
  for M in 1 .. 140:
    let c = calc(M)
    ans += c
  echo ans
  Naive:
    proc dsum(N:int):int =
      var d = block:
        var
          N = N
          d:seq[int]
        while N > 0:
          d.add N mod 10
          N.div=10
        d
      return d.sum
    ans := 0
    ans0 := Seq[140: seq[int]]
    for N in 1 .. N:
      let s = dsum(N)
      if N mod s == 0:
        ans.inc
        ans0[s].add N
    echo ans
  discard


when not DO_TEST:
  var N = nextInt()
  solve(N)
else:
  test(2024)
  discard

