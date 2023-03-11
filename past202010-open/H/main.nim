include atcoder/extra/header/chaemon_header

import atcoder/extra/dp/cumulative_sum_2d

const DEBUG = true

# Failed to predict input format
block main:
  let N, M, K = nextInt()
  let S = newSeqWith(N, nextString())
  var v = Seq[CumulativeSum2D[int]]
  for d in 0..9:
    var cs = initCumulativeSum2D[int](N, M)
    for i in 0..<N:
      for j in 0..<M:
        if S[i][j].ord != '0'.ord + d: continue
        cs.add(i, j, 1)
    cs.build()
    v.add(cs)
  for n in countdown(min(N, M), 1):
    for d in 0..9:
      for i in 0..N-n:
        for j in 0..M-n:
          if n * n - v[d][i..<i+n, j..<j+n] <= K:
            echo n;break main
  discard

