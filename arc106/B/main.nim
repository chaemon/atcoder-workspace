include atcoder/extra/header/chaemon_header
import atcoder/dsu

const YES = "Yes"
const NO = "No"

proc solve(N:int, M:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int]) =
  var uf = initDSU(N)
  for i in 0..<M: uf.merge(c[i], d[i])
  var v = uf.groups()
  for v in v:
    var sa, sb = 0
    for u in v:
      sa += a[u]
      sb += b[u]
    if sa != sb:
      echo NO;return
  echo YES
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(N, nextInt())
  var b = newSeqWith(N, nextInt())
  var c = newSeqWith(M, 0)
  var d = newSeqWith(M, 0)
  for i in 0..<M:
    c[i] = nextInt() - 1
    d[i] = nextInt() - 1
  solve(N, M, a, b, c, d)
#}}}
