include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"
var N:int
var A:seq[int]
var B:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
  B = newSeqWith(N, nextInt())
#}}}

proc main() =
  var C, D = newSeq[int](N + 1)
  block:
    var j = 0
    for i in 0..N:
      while j < N and A[j] <= i: j.inc
      C[i] = j
  block:
    var j = 0
    for i in 0..N:
      while j < N and B[j] <= i: j.inc
      D[i] = j
  for i in 1..N:
    var s = 0
    s += C[i] - C[i - 1]
    s += D[i] - D[i - 1]
    if s > N:
      echo NO
      return
  var x = -int.inf
  for i in 1..N:
    x >?= C[i] - D[i - 1]
  var B2 = newSeq[int](N)
  for i in 0..<N:
    B2[(i + x) mod N] = B[i]
  echo YES
  echo B2.join(" ")
  return

main()

