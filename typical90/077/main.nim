const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header


const YES = "Yes"
const NO = "No"

solveProc solve(N:int, T:int, AX:seq[int], AY:seq[int], BX:seq[int], BY:seq[int]):
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var T = nextInt()
  var AX = newSeqWith(N, 0)
  var AY = newSeqWith(N, 0)
  for i in 0..<N:
    AX[i] = nextInt()
    AY[i] = nextInt()
  var BX = newSeqWith(N, 0)
  var BY = newSeqWith(N, 0)
  for i in 0..<N:
    BX[i] = nextInt()
    BY[i] = nextInt()
  solve(N, T, AX, AY, BX, BY)
#}}}

