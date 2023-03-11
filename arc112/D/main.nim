include atcoder/extra/header/chaemon_header

import atcoder/scc

const DEBUG = true

let H, W = nextInt()
let S = Seq(H, nextString())

g := initSCCGraph(H + W)

for u in 0..<W:
  g.addEdge(u + H, 0)
  g.addEdge(u + H, H - 1)
for u in 0..<H:
  g.addEdge(u, H)
  g.addEdge(u, H + W - 1)

for u in 0..<H:
  for v in 0..<W:
    if S[u][v] == '#':
      g.addEdge(u, v + H)
      g.addEdge(v + H, u)

groups := g.scc()

belongs := Seq(H + W, -1)

for i,g in groups:
  for u in g:
    belongs[u] = i

var ans = int.inf

block:
  s := initSet[int]()
  for u in 0..<H:
    s.incl(belongs[u])
  ans.min=s.len - 1
block:
  s := initSet[int]()
  for u in 0..<W:
    s.incl(belongs[u + H])
  ans.min=s.len - 1

echo ans

