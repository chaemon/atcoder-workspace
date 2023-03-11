include atcoder/extra/header/chaemon_header

var N:int
var M:int
var A:seq[int]
var B:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(M, 0)
  B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
#}}}

import atcoder/dsu

proc main() =
  var uf = initDSU(N)
  for i in 0..<M:
    uf.merge(A[i], B[i])
  let t = uf.groups.len
  echo t - 1
  return

main()

