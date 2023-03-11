include atcoder/extra/header/chaemon_header

var N:int
var A:seq[int]
var B:seq[int]
var M:int
var T:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  M = nextInt()
  T = newSeqWith(M, nextInt())
#}}}

proc main() =
  return

main()

