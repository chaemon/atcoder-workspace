include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"
var N:int
var D:seq[seq[int]]

# input part {{{
proc main()
block:
  N = nextInt()
  D = newSeqWith(N, newSeqWith(2, nextInt()))
#}}}

proc main() =
  for i in 0..N-3:
    if D[i][0] == D[i][1] and D[i + 1][0] == D[i + 1][1] and D[i + 2][0] == D[i + 2][1]:
      echo YES
      return
  echo NO
  return

main()

