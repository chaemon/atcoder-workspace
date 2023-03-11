const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, D:seq[int], C:seq[int], S:seq[int]):
  const M = 5000
  # 締切が早い順にsort
  var v: seq[tuple[D, C, S:int]]
  for i in N:
    v.add (D[i], C[i], S[i])
  v.sort
  var (D, C, S) = (D, C, S)
  for i in N:
    D[i] = v[i].D
    C[i] = v[i].C
    S[i] = v[i].S
  var dp = Array[M + 1: 0]
  for i in N:
    var dp2 = dp
    for d in 0 ..< M:
      # d日目から仕事iを行う
      if d + C[i] <= D[i]:
        dp2[d + C[i]].max= dp[d] + S[i]
    dp = dp2.move
  echo dp.max
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var D = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var S = newSeqWith(N, 0)
  for i in 0..<N:
    D[i] = nextInt()
    C[i] = nextInt()
    S[i] = nextInt()
  solve(N, D, C, S)
#}}}

