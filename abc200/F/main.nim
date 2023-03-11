include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 1000000007
type mint = modint1000000007

import atcoder/extra/math/matrix

const DEBUG = true

proc solve(S:string, K:int) =
  var dp = Seq[2, 2, 2, 2: mint] # start, end, parity, num-sum
  for s in 0..1:
    var dpn, dps = Seq[2, 2: mint] # end, parity
    if s == 0:
      if S[0] == '?' or S[0] == '0':
        dpn[0][1] = 1;dps[0][1] = 1
    else:
      if S[0] == '?' or S[0] == '1':
        dpn[1][1] = 1;dps[1][1] = 1
    for i in 1 ..< S.len:
      var dpn2, dps2 = Seq[2, 2: mint]
      for p in 0..1:
        let np = 1 - p
        if S[i] == '?' or S[i] == '0': # make 0
          # 0 -> 0
          dpn2[0][p] += dpn[0][p]
          dps2[0][p] += dps[0][p]
          # 1 -> 0
          dpn2[0][np] += dpn[1][p]
          dps2[0][np] += dps[1][p] + dpn[1][p]
        if S[i] == '?' or S[i] == '1': # make 1
          # 0 -> 1
          dpn2[1][np] += dpn[0][p]
          dps2[1][np] += dps[0][p] + dpn[0][p]
          # 1 -> 1
          dpn2[1][p] += dpn[1][p]
          dps2[1][p] += dps[1][p]
      swap dpn, dpn2
      swap dps, dps2
    for e in 0..1:
      for p in 0..1:
        dp[s][e][p][0] = dpn[e][p]
        dp[s][e][p][1] = dps[e][p]
  id(e, p, t:int) => e * 4 + p * 2 + t # end, parity, num or sum
  type Mat = MatrixType(mint)
  var
    A = Mat.init(8, 8)
    b = Mat.initVector(8)
  for s in 0..1:
    for e in 0..1:
      for p in 0..1:
        let
          ni = id(e, p, 0)
          si = id(e, p, 1)
        b[ni] += dp[s][e][p][0]
        b[si] += dp[s][e][p][1]
  for e in 0..1:
    for p in 0..1:
      let
        ni = id(e, p, 0)
        si = id(e, p, 1)
      for s2 in 0..1:
        for pn in 0..1:
          for e2 in 0..1:
            var p2 = (p + pn) mod 2
            if e == s2: p2 = 1 - p2
            let
              nv = dp[s2][e2][pn][0]
              sv = dp[s2][e2][pn][1]
              ni2 = id(e2, p2, 0)
              si2 = id(e2, p2, 1)
            A[ni2][ni] += nv
            A[si2][si] += nv
            A[si2][ni] += sv
            if e == s2:
              A[si2][ni] -= nv
  b = A^(K - 1) * b
  var ans = mint(0)
  for e in 0..1:
    for p in 0..1:
      let
        ni = id(e, p, 0)
        si = id(e, p, 1)
      if p == 0:
        ans += b[si]
      else:
        ans += b[si] - b[ni]
  ans /= 2
  echo ans
  return

# input part {{{
block:
  var S = nextString()
  var K = nextInt()
  solve(S, K)
#}}}

