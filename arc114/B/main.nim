include atcoder/extra/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const DEBUG = true

proc solve(N:int, f:seq[int]) =
  vis := Seq(N, int.inf)
  ans := mint(1)
  p := 0
  for u in 0..<N:
    if vis[u] < p: continue
    vis[u] = p
    valid := true
    if f[u] == u:
      discard
    else:
      t := u
      while true:
        vis[t] = p
        t = f[t]
        if vis[t] < p:
          valid = false
          break
        elif vis[t] == p:
          break
        elif t == u: break
    p.inc
    if valid:
      ans *= 2
  ans.dec
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var f = newSeqWith(N, nextInt() - 1)
  solve(N, f)
#}}}

