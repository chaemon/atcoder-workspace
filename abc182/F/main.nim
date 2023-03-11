include atcoder/extra/header/chaemon_header


proc solve() =
  var N, X = nextInt()
  let A = Seq(N, nextInt())
  var d = newSeq[int]()
  for i in 0..<N - 1: d.add(A[i + 1] div A[i])
  d.add int.inf
  var x = newSeq[int]()
  for i in 0..<N << 1:
    x.add X div A[i]
    X = X mod A[i]
  x.reverse
  var dp = @[1, 0]
  for i in 0..<N << 1:
    var dp2 = newSeq[int](2)
    for c in 0..1:
      block:
        # make yi = 0
        var c2 = 0
        var zi = -c - x[i]
        if zi < 0:
          if i == N - 1: break
          zi += d[i]
          c2 = 1
        assert 0 <= zi and zi < d[i]
        dp2[c] += dp[c2]
      block:
        # make zi = 0
        var c2 = 0
        var yi = c + x[i]
        if yi >= d[i]:
          yi -= d[i]
          c2 = 1
        assert 0 <= yi and yi < d[i]
        if yi != 0:
          dp2[c] += dp[c2]
    swap dp, dp2
  echo dp[0]
  return

# input part {{{
block:
# Failed to predict input format
  solve()
#}}}
