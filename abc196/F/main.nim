include atcoder/extra/header/chaemon_header

import atcoder/modint
import atcoder/convolution

type mint = modint998244353

const DEBUG = true

proc solve(S:string, T:string) =
  var x0, x1 = Seq(S.len, mint)
  for i in 0..<S.len:
    if S[i] == '0': x0[i] = 1
    else: x1[i] = 1
  var y0, y1 = Seq(T.len, mint)
  for i in 0..<T.len:
    if T[i] == '0': y0[i] = 1
    else: y1[i] = 1
  y0.reverse
  y1.reverse
  let z0 = x0.convolution(y0)
  let z1 = x1.convolution(y1)
  var ans = 0
  let s = T.len - 1
  for i in 0..S.len - T.len:
    ans.max = (z0[s+i] + z1[s+i]).val
  echo T.len - ans
  return

# input part {{{
block:
  var S = nextString()
  var T = nextString()
  solve(S, T)
#}}}

