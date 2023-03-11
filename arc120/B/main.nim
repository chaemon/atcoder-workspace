include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

proc solve(H:int, W:int, S:seq[string]) =
  var v = Seq[H + W - 1: (R:false, B:false, Q:0)]
  for i in H:
    for j in W:
      let s = i + j
      if S[i][j] == 'R':
        v[s].R = true
      elif S[i][j] == 'B':
        v[s].B = true
      else:
        v[s].Q.inc
  var ans = mint(1)
  for i in 0..<H+W-1:
    if v[i].R and v[i].B: echo 0;return
    if not v[i].R and not v[i].B: ans *= 2
  echo ans
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
#}}}

