include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, M:int, K:int, RX:seq[int], RY:seq[int], BX:seq[int], BY:seq[int]) =
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var RX = newSeqWith(N, 0)
  var RY = newSeqWith(N, 0)
  for i in 0..<N:
    RX[i] = nextInt()
    RY[i] = nextInt()
  var BX = newSeqWith(M, 0)
  var BY = newSeqWith(M, 0)
  for i in 0..<M:
    BX[i] = nextInt()
    BY[i] = nextInt()
  solve(N, M, K, RX, RY, BX, BY)
#}}}

