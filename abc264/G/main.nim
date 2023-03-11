const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/graph/graph_template
import lib/graph/bellman_ford

solveProc solve(N:int, T:seq[string], P:seq[int]):
  proc id(a:string):int =
    doAssert a.len == 2
    return (a[0].ord - 'a'.ord) * 26 + (a[1].ord - 'a'.ord)
  var score = initTable[string, int]()
  proc calc_score(s:string):int =
    if s notin score: return 0
    else: return score[s]
  for i in N:
    score[T[i]] = P[i]
  const B = 26 * 26
  var g = initGraph[int](B + 1)
  let s = B
  for x0 in 'a'..'z':
    for x1 in 'a'..'z':
      d := calc_score("" & x0) + calc_score("" & x1) + calc_score(x0 & x1)
      g.addEdge(s, id(x0 & x1), -d)
  for x0 in 'a'..'z':
    for x1 in 'a'..'z':
      let x = x0 & x1
      static:
        doAssert x is string
      let y0 = x1
      for y1 in 'a'..'z':
        let y = y0 & y1
        # x0 x1 = y0 y1
        d := calc_score(x0 & y0 & y1) + calc_score(y0 & y1) + calc_score("" & y1)
        g.addEdge(id(x), id(y), -d)
  var r = g.bellman_ford(s)
  if r.negative_cycle:
    echo "Infinity"
  else:
    ans := -int.inf
    for x in 'a' .. 'z':
      ans.max=calc_score("" & x)
    for x0 in 'a'..'z':
      for x1 in 'a'..'z':
        let xi = id(x0 & x1)
        if r[xi] == int.inf: continue
        ans.max= -r[xi]
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, "")
  var P = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextString()
    P[i] = nextInt()
  solve(N, T, P)
else:
  discard

