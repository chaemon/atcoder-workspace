include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(Q:int, x:seq[int], y:seq[int]) =
  return

# input part {{{
block:
  var Q = nextInt()
  var x = newSeqWith(Q, 0)
  var y = newSeqWith(Q, 0)
  for i in 0..<Q:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(Q, x, y)
#}}}
