include atcoder/extra/header/chaemon_header
import atcoder/extra/dp/cumulative_sum

var dp = Array(-1..503, 503, int.inf)

proc solve(N:int, A:seq[seq[int]]) =
#  var edge_from, edge_to = Seq(N, initCumulativeSum[int](N))
  var
    edge_from = collect(newSeq):
      for i in 0..<N:
        initCumulativeSum[int](N)
    edge_to = edge_from
  for i in 0..<N:
    for j in 0..<N:
      edge_from[i][j] = A[i][j]
      edge_to[j][i] = A[i][j]
  var ans = int.inf
  dp[-1][0] = 0
  for i in -1..<N-1:
    for j in i + 1..<N:
      var v = dp[i][j]
      if v == int.inf: continue
      for k in j..<N-1: # i..<j, j..k
        # different(-1)
        dp[j][k + 1].min= v + edge_from[k + 1][0..<j]
        # same(0)
        v += edge_to[k + 1][j..k] + edge_from[k + 1][0..<i]
      ans.min=v
  echo ans
  return

#{{{ main function
proc main() =
  var N = 0
  N = nextInt()
  var A = Seq(N, N, 0)
  for i in 0..<N:
    for j in 0..<N:
      if i == j: continue
      A[i][j] = nextInt()
  solve(N, A)
  return

main()
#}}}
