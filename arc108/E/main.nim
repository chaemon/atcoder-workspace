include atcoder/extra/header/chaemon_header

import atcoder/modint
import atcoder/fenwicktree
import atcoder/extra/math/combination

type mint = modint1000000007

var dp = Array(2002, 2002, mint(0))

proc solve(N:int, a:seq[int]) =
  let a = 0 & a & N + 1
  type ftt = FenwickTree.getType(mint)
  var ftr = newSeqWith(a.len, ftt.init(a.len))
  var ftl = ftt.init(a.len)
  var ct = getFenwickTreeType(int).init(a.len)
  for l in reversed(0..<a.len):
    ct.init(a.len)
    ftl.init(a.len)
    for r in l + 1..<a.len:
      if a[l] > a[r]: continue
      let c = ct.sum(0..a[r])
      ct.add(a[r], 1)
      if c == 0: continue
      dp[l][r] = (ftl.sum(a[l]+1..<a[r]) + ftr[r].sum(a[l]+1..<a[r])) * mint.inv(c) + 1
      ftl.add(a[r], dp[l][r])
      ftr[r].add(a[l], dp[l][r])
  echo dp[0][N + 1]
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
#}}}
