include atcoder/extra/header/chaemon_header

const YES = "Yes"
const NO = "No"

proc solve(N:int, S:int, D:int, X:seq[int], Y:seq[int]) =
  for i in 0..<N:
    if X[i] >= S:continue
    if Y[i] <= D:continue
    echo YES;return
  echo NO
  return

# input part {{{
block:
  var N = nextInt()
  var S = nextInt()
  var D = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, S, D, X, Y)
#}}}
