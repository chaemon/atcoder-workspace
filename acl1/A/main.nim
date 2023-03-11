include atcoder/extra/header/chaemon_header

var N:int
var x:seq[int]
var y:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  x = newSeqWith(N, 0)
  y = newSeqWith(N, 0)
  for i in 0..<N:
    x[i] = nextInt()
    y[i] = nextInt()
#}}}

import atcoder/dsu

proc main() =
  var v = newSeq[(int,int)]()
  for i in 0..<N:
    v.add((x[i], i))
  v.sort()
  var uf = initDSU(N)
  var s = newSeq[int]()
  for (x, i) in v:
    if s.len == 0 or y[s[^1]] > y[i]: s.add(i)
    else:
      let j = s.pop()
      uf.merge(i, j)
      while s.len > 0 and y[s[^1]] < y[i]:
        let k = s.pop()
        uf.merge(k, j)
      s.add(j)
  for k in 0..<N:
    echo uf.size(k)
  return

main()
