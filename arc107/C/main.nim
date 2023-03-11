include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import atcoder/extra/math/combination
import atcoder/dsu

proc solve(N:int, K:int, a:seq[seq[int]]) =
  var ans = mint(1)
  block:
    uf := initDSU(N)
    for i in 0..<N:
      for j in i+1..<N:
        var valid = true
        for k in 0..<N:
          if a[i][k] + a[j][k] > K:
            valid = false
        if valid: uf.merge(i, j)
    for g in uf.groups:
      ans *= mint.fact(g.len)
  block:
    uf := initDSU(N)
    for i in 0..<N:
      for j in i+1..<N:
        var valid = true
        for k in 0..<N:
          if a[k][i] + a[k][j] > K:
            valid = false
        if valid: uf.merge(i, j)
    for g in uf.groups:
      ans *= mint.fact(g.len)
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var a = newSeqWith(N, newSeqWith(N, nextInt()))
  solve(N, K, a)
#}}}
