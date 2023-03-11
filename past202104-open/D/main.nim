include atcoder/extra/header/chaemon_header


const DEBUG = true

proc solve(N:int, K:int, A:seq[int]) =
  let c = (0 & A).cumsummed
  for i in N - K + 1:
    echo c[i + K] - c[i]
    discard
  return

# input part {{{
block:
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
#}}}

