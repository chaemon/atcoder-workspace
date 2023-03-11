include atcoder/extra/header/chaemon_header
#import atcoder/extra/graph/eulerian_trail
import atcoder/dsu

const YES = "YES"
const NO = "NO"

proc solve(N:int, H:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]) =
  let MAX = H + 10
  var dsu = initDSU(MAX * 2)
  var vis = Seq(MAX * 2, false)
  id(x, y:int) => x * MAX + y
#  var et = initEulerianTrail(2 * (H + 1), true)
  var deg = newSeqWith(2 * MAX, 0)
  for i in 0..<N:
    var u, v:int
    if C[i] == 0:
      u = id(0, A[i])
    else:
      u = id(1, C[i])
    if D[i] == 0:
      v = id(1, B[i])
    else:
      v = id(0, D[i])
    deg[u].inc
    deg[v].dec
    dsu.merge(u, v)
    vis[u] = true
    vis[v] = true
  for i in 0..<MAX:
    if deg[i] < 0:
      echo NO;return
  for i in MAX..<MAX * 2:
    if deg[i] > 0:
      echo NO;return
  for g in dsu.groups:
    if g.len == 1 and not vis[g[0]]: continue
    valid := false
    for u in g:
      if deg[u] != 0: valid = true
    if not valid:
      echo NO;return
  echo YES
  return

# input part {{{
block:
  var N = nextInt()
  var H = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, H, A, B, C, D)
#}}}
