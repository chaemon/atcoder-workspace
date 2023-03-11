include atcoder/extra/header/chaemon_header

var N:int
var K:int
var A:seq[int]
var B:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  A = newSeqWith(N, 0)
  B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
#}}}

proc main() =
  return

main()

