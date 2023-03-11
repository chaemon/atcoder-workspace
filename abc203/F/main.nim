include atcoder/extra/header/chaemon_header

const DEBUG = false

proc solve(N:int, K:int, A:seq[int]) =
  debug A
  var r = Seq[N + 1: seq[int]]
  for i in 0..<N:
    let H = A[i] div 2 + 1
    let j = A.lower_bound(H)
    r[i + 1].add(j)
  debug r
  const B = 32
  var dp = Seq[N + 1, B: int.inf]
  dp[0][0] = 0
  for i in 0..<N:
    for T in 0..<B:
      # 0..i
      block:
        let A = dp[i][T]
        if A + 1 <= K:
          dp[i + 1][T].min=A + 1
      debug i, dp[i + 1]
      block:
        for l in r[i + 1]:
          var A = dp[l][T]
          if T + 1 < B:
            dp[i + 1][T + 1].min=A
    debug dp
  for T in 0..<B:
    if dp[N][T] != int.inf:
      echo T, " ", dp[N][T]
      return
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  A.sort()
  solve(N, K, A)
#}}}

