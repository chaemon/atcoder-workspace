when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/dp/cumulative_sum_2d

solveProc solve(H:int, W:int, T:int, s:seq[seq[int]]):
  var cs = initCumulativeSum2d[int](H, W)
  for i in H:
    for j in W:
      cs.add(i, j, s[i][j])
  cs.build()
  var v:seq[int]
  for i in H:
    for i2 in i + 1 .. H:
      for j in W:
        for j2 in j + 1 .. W:
          v.add cs[i ..< i2, j ..< j2]
  v.sort
  v = v.deduplicate(isSorted = true)
  var ans = int.inf
  # B以上での分割を考える
  for B in v:
    var dp = [H + 1, H + 1, W + 1, W + 1, H * W] @ int.inf
    # dp[i][i2][j][j2]: i ..< i2, j ..< j2で切り出した長方形でT回切ってB以上に分割するときの個数最小値
    for dh in 1 .. H:
      for dw in 1 .. W:
        for i in 0 .. H - dh:
          let i2 = i + dh
          for j in 0 .. W - dw:
            let j2 = j + dw
            let s = cs[i ..< i2, j ..< j2]
            if s >= B:
              dp[i][i2][j][j2][0] = s
            for t in 1 ..< dh * dw:
              p =& dp[i][i2][j][j2][t]
              # i ..< i2をi ..< k, k ..< i2に分割
              for k in i + 1 .. i2 - 1:
                for t2 in 0 .. t - 1:
                  # t2, t - t2 - 1
                  p.min=max(dp[i][k][j][j2][t2], dp[k][i2][j][j2][t - t2 - 1])
              # j ..< j2をj ..< k, k ..< j2に分割
              for k in j + 1 .. j2 - 1:
                for t2 in 0 .. t - 1:
                  p.min=max(dp[i][i2][j][k][t2], dp[i][i2][k][j2][t - t2 - 1])
    let t = dp[0][H][0][W][T]
    if t != int.inf:
      ans.min=t - B
  echo ans
  discard

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var T = nextInt()
  var s = newSeqWith(H, newSeqWith(W, nextInt()))
  solve(H, W, T, s)
else:
  discard

