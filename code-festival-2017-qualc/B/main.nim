include atcoder/extra/header/chaemon_header

var N:int
var A:seq[int]

# input part {{{
proc main()
block:
  N = nextInt()
  A = newSeqWith(N, nextInt())
#}}}

proc main() =
  var ans = 1
  for i in 0..<N:
    if A[i] mod 2 == 0:
      ans *= 2
    else:
      ans *= 1
  ans = 3^N - ans
  echo ans
  return

main()

