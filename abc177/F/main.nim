include src/nim_acl/extra/header/chaemon_header

var H:int
var W:int
var A:seq[int]
var B:seq[int]

# input part {{{
proc main()
block:
  H = nextInt()
  W = nextInt()
  A = newSeqWith(H, 0)
  B = newSeqWith(H, 0)
  for i in 0..<H:
    A[i] = nextInt()
    B[i] = nextInt()
#}}}

proc main() =
  return

main()

