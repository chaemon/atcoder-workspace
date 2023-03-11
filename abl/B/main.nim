include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"
var A:int
var B:int
var C:int
var D:int

# input part {{{
proc main()
block:
  A = nextInt()
  B = nextInt()
  C = nextInt()
  D = nextInt()
#}}}

proc main() =
  if max(A, C) <= min(B, D):
    echo YES
  else:
    echo NO
  return

main()

