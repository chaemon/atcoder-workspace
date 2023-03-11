include atcoder/extra/header/chaemon_header

import atcoder/extra/graph/graph_template
import atcoder/extra/graph/dijkstra

const DEBUG = true

# Failed to predict input format
block main:
  let N = nextInt()
  var X, C = Seq[N : int]
  tb := initTable[int, seq[int]]()
#  var tb = initTable[int, seq[int]]()
  for i in 0..<N:
    X[i] = nextInt()
    C[i] = nextInt() - 1
    if C[i] notin tb:
      tb[C[i]] = Seq[int]
    tb[C[i]].add(X[i])
  v := Seq[int]
  for k in tb.keys:
    v.add(k)
  v.sort()
  var ans = @[(0, 0)]
  for k in v:
#    var ans2 = Seq[(int,int)]
    var p = tb[k]
    let l = p.min
    let r = p.max
    var ln, rn = int.inf
    for (x, n) in ans:
      if n == int.inf: continue
      if x < l:
        rn.min= r - x + n
      elif r < x:
        ln.min= x - l + n
      else:
        ln.min= r - x + r - l + n
        rn.min= x - l + r - l + n
    var ans2 = @[(l, ln), (r, rn)]
    swap(ans, ans2)
#    debug p, l, r, ans
  echo min(ans[0][0].abs + ans[0][1], ans[1][0].abs + ans[1][1])
  discard

