include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template

#const DEBUG = true

proc solve(n:int, p:seq[int]) =
  g := initGraph[int](n)
  for i in 1..<n:
    g.addBiEdge(p[i - 1], i)
  size := Seq(n, int)
  proc dfs(u:int, p:int):int =
    debug u, p
    var even, odd = newSeq[int]()
    size[u] = 1
    for e in g[u]:
      if e.dst == p: continue
      x := dfs(e.dst, u)
      size[u] += size[e.dst]
      y := size[e.dst] - x
      if size[e.dst] mod 2 == 0:
        even.add(y - x)
      else:
        odd.add(y - x)
    even.sort(Sortorder.Descending)
    odd.sort(Sortorder.Descending)
    ans := 0
    i := 0
    j := 0
    turn := 0
    while i < even.len:
      if even[i] > 0:
        ans += even[i]
        i.inc
      else:
        break
    while j < odd.len:
      if turn == 0:
        ans += odd[j]
      else:
        ans -= odd[j]
      j.inc
      turn = 1 - turn
    while i < even.len:
      if turn == 0:
        ans += even[i]
      else:
        ans -= even[i]
      i.inc
    debug ans, size[u]
    assert (ans + size[u] - 1) mod 2 == 0
    let x = (ans + size[u] - 1) div 2
    let y = size[u] - x
    debug u, p, x, y, odd, even
    return y
  let t = dfs(0, -1)
  echo t

# input part {{{
block:
  var n = nextInt()
  var p = newSeqWith(n-2+1, nextInt() - 1)
  solve(n, p)
#}}}

