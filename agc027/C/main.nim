include atcoder/extra/header/chaemon_header

import options
import atcoder/extra/graph/graph_template
import atcoder/extra/graph/cycle_detection

const YES = "Yes"
const NO = "No"

proc solve(N:int, M:int, s:string, a:seq[int], b:seq[int]) =
  var g = initGraph[int](N * 2)
  for i in 0..<M:
    if s[a[i]] == s[b[i]]:
      g.addEdge(a[i] * 2, b[i] * 2 + 1)
      g.addEdge(b[i] * 2, a[i] * 2 + 1)
    else:
      g.addEdge(a[i] * 2 + 1, b[i] * 2)
      g.addEdge(b[i] * 2 + 1, a[i] * 2)
  let v = g.cycle_detection
  if v.isSome(): echo YES
  else: echo NO
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var s = nextString()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, M, s, a, b)
#}}}
