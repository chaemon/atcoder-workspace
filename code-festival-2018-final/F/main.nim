include atcoder/extra/header/chaemon_header

var N:int
var K:int
var T:seq[int]
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  K = nextInt()
  T = newSeqWith(N, 0)
  A = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    A[i] = nextInt()
#}}}

proc main() =
  return

main()

