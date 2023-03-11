include atcoder/extra/header/chaemon_header

import atcoder/modint

var N:int
var K:int

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
#}}}

proc main() =
  var vis = Seq(N, N, 2, false)
  var pr = Seq(N, N, 2, 0.0)
  proc calc(i, j, b:int):float = # appeared i, eat k
    if i == N: return b
    r =& pr[i][j][b]
    if vis[i][j][b]: return r
    vis[i][j][b] = true
    r = 0.0
    # eat
    if j < K: r.max= calc(i + 1, j + 1, 1)
    # not eat
    r.max= calc(i + 1, j, 0)
    r = r / (i + 1) + i / (i + 1) * calc(i + 1, j, b)
    return r
  echo calc(0, 0, 1)
  return

main()
