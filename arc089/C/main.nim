include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(N:int, t:seq[int], x:seq[int], y:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var t = newSeqWith(N, 0)
  var x = newSeqWith(N, 0)
  var y = newSeqWith(N, 0)
  for i in 0..<N:
    t[i] = nextInt()
    x[i] = nextInt()
    y[i] = nextInt()
  solve(N, t, x, y)
#}}}
