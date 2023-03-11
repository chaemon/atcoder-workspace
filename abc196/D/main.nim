include atcoder/extra/header/chaemon_header

import atcoder/extra/other/bitutils

#const DEBUG = true

proc solve(H:int, W:int, A:int, B:int) =
  var dp = Seq(2^(H * W), A + 1, B + 1, -1)
  proc encode(a:seq[seq[bool]]):int =
    var t = 0
    result = 0
    for i in 0..<H:
      for j in 0..<W:
        if a[i][j]: result[t] = 1
        t.inc
  proc decode(b:int):seq[seq[bool]] =
    var t = 0
    result = Seq(H, W, false)
    for i in 0..<H:
      for j in 0..<W:
        if b[t]: result[i][j] = true
        t.inc

  proc calc(b, x, y:int):int =
    d =& dp[b][x][y]
    if d >= 0: return d
    var a = b.decode
    var i0, j0 = -1
    for i in 0..<H:
      if i0 != -1: break
      for j in 0..<W:
        if i0 != -1: break
        if not a[i][j]:
          i0 = i
          j0 = j
    if i0 == -1:
      result = 1
    else:
      debug a, i0, j0
      a[i0][j0] = true
      if y + 1 <= B:
        result += calc(a.encode, x, y + 1)
      if i0 + 1 < H and x + 1 <= A and not a[i0 + 1][j0]:
        a[i0 + 1][j0] = true
        result += calc(a.encode, x + 1, y)
        a[i0 + 1][j0] = false
      if j0 + 1 < W and x + 1 <= A and not a[i0][j0 + 1]:
        a[i0][j0 + 1] = true
        result += calc(a.encode, x + 1, y)
        a[i0][j0 + 1] = false
      a[i0][j0] = false
    d = result
    debug a, x, y, result
  echo calc(0, 0, 0)
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var A = nextInt()
  var B = nextInt()
  solve(H, W, A, B)
#}}}

