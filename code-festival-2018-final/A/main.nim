include atcoder/extra/header/chaemon_header

var N:int
var M:int
var A:seq[int]
var B:seq[int]
var L:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(M, 0)
  B = newSeqWith(M, 0)
  L = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
    L[i] = nextInt()
#}}}

proc main() =
  return

main()

