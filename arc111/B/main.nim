include atcoder/extra/header/chaemon_header

import atcoder/dsu

const M = 400000

proc solve(N:int, a:seq[int], b:seq[int]) =
  var dsu = initDSU(M)
  ct := newSeq[int](M)
  for i in 0..<N:
    if dsu.leader(a[i]) != dsu.leader(b[i]):
      let x = ct[dsu.leader(a[i])]
      let y = ct[dsu.leader(b[i])]
      dsu.merge(a[i], b[i])
      ct[dsu.leader(a[i])] = x + y + 1
    else:
      ct[dsu.leader(a[i])].inc
  var ans = 0
  for g in dsu.groups:
    if g.len == 1 and ct[g[0]] == 0: continue
    if g.len == ct[dsu.leader(g[0])] + 1:
      ans += g.len - 1
    else:
      ans += g.len
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(N, 0)
  var b = newSeqWith(N, 0)
  for i in 0..<N:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, a, b)
#}}}
