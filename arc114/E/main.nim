include atcoder/extra/header/chaemon_header

import atcoder/extra/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

proc solve(H:int, W:int, h:seq[int], w:seq[int]) =
  var (h, w) = (h, w)
  h2 := h
  h2[0] = min(h[0], h[1])
  h2[1] = max(h[0], h[1])
  swap(h, h2)
  w2 := w
  w2[0] = min(w[0], w[1])
  w2[1] = max(w[0], w[1])
  swap(w, w2)
  let
    T = [h[0], H - 1 - h[1], w[0], W - 1 - w[1]]
    E = H - 1 + W - 1 - T.sum
  ans := mint(1)
  for i in 0..<T.len:
    for j in 0..<T[i]:
      ans += mint.inv(j + E + 1)
  echo ans
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var h = newSeqWith(2, 0)
  var w = newSeqWith(2, 0)
  for i in 0..<2:
    h[i] = nextInt() - 1
    w[i] = nextInt() - 1
  solve(H, W, h, w)
#}}}

