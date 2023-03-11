include atcoder/extra/header/chaemon_header

import atcoder/modint

const MOD = 1000000007

type mint = modint1000000007

proc solve(H:int, W:int, S:seq[string]) =
  var K = 0
  for i in 0..<H:
    for j in 0..<W:
      if S[i][j] == '.': K.inc
  var ans = mint(0)
  var left, right, up, down = Seq(H, W, -1)
  var vis = Seq(H, W, false)
  var p = newSeq[mint](H * W + 1)
  p[0] = mint(1)
  for i in 1..<p.len:
    p[i] = p[i - 1] * 2
  for i in 0..<H:
    for j in 0..<W:
      if i == 0 or S[i - 1][j] == '#': left[i][j] = 0
      else: left[i][j] = left[i - 1][j] + 1
  for i in countdown(H - 1, 0):
    for j in 0..<W:
      if i == H - 1 or S[i + 1][j] == '#': right[i][j] = 0
      else: right[i][j] = right[i + 1][j] + 1
  for j in 0..<W:
    for i in 0..<H:
      if j == 0 or S[i][j - 1] == '#': up[i][j] = 0
      else: up[i][j] = up[i][j - 1] + 1
  for j in countdown(W - 1, 0):
    for i in 0..<H:
      if j == W - 1 or S[i][j + 1] == '#': down[i][j] = 0
      else: down[i][j] = down[i][j + 1] + 1
  for i in 0..<H:
    for j in 0..<W:
      if S[i][j] == '#': continue
      let t = 1 + left[i][j] + right[i][j] + down[i][j] + up[i][j]
      ans += (p[t] - 1) * p[K - t]
  echo ans
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var S = newSeqWith(H, nextString())
  solve(H, W, S)
#}}}
