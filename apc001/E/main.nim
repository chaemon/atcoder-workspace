include atcoder/extra/header/chaemon_header

var N:int
var a:seq[int]
var b:seq[int]

#{{{ input part
proc main()
block:
  N = nextInt()
  a = newSeqWith(N-2-0+1, 0)
  b = newSeqWith(N-2-0+1, 0)
  for i in 0..<N-2-0+1:
    a[i] = nextInt()
    b[i] = nextInt()
#}}}

const DEBUG = true
import atcoder/extra/graph/graph_template
import atcoder/extra/graph/graphviz

proc main() =
  g := initUndirectedGraph[int](N, a, b)
#  g.graphviz()
  var r = -1
  for u in 0..<N:
    if g[u].len >= 3: r = u;break
  if r == -1:
    echo 1;return

  proc dfs(g:Graph[int], u:int, p:int):(int, int) =
    if g[u].len == 1: return (0, 1)
    var v = newSeq[(int,int)]()
    var s = 0
    for e in g[u]:
      if e.dst == p: continue
      v.add(g.dfs(e.dst, u))
      s += v[^1][1]
    var ans0 = int.inf
    if v.len == 1 and v[0][0] == 0: ans0 = 0
    var ans1 = s
    for i in v.len: 
      ans1.min= s - v[i][1] + v[i][0]
    if ans1 == 0: ans1 = 1
    return (ans0, ans1)
  let (ans0, ans1) = g.dfs(r, -1)
  echo ans1
  return

main()
