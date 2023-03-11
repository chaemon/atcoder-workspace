include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(S:int, P:int) =
  for N in 1..10^6:
    if P mod N == 0:
      let M = P div N
      if N + M == S:
        echo YES;return
  echo NO
  return

# input part {{{
block:
  var S = nextInt()
  var P = nextInt()
  solve(S, P)
#}}}
