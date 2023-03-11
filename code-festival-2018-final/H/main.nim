include atcoder/extra/header/chaemon_header

var N:int
var M:int
var A:seq[int]
var B:seq[int]
var D:seq[int]
var S:seq[int]
var E:seq[int]
var C:seq[int]
var X:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  M = nextInt()
  A = newSeqWith(N-1, 0)
  B = newSeqWith(N-1, 0)
  D = newSeqWith(N-1, 0)
  for i in 0..<N-1:
    A[i] = nextInt()
    B[i] = nextInt()
    D[i] = nextInt()
  S = newSeqWith(M, 0)
  E = newSeqWith(M, 0)
  C = newSeqWith(M, 0)
  X = newSeqWith(M, 0)
  for i in 0..<M:
    S[i] = nextInt()
    E[i] = nextInt()
    C[i] = nextInt()
    X[i] = nextInt()
#}}}

proc main() =
  return

main()

