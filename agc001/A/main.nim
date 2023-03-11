include atcoder/extra/header/chaemon_header

var N:int
var L:seq[int]

proc solve() =
  L.sort()
  var ans = 0
  for i in countup(0, 2 * N - 1, 2):
    ans += min(L[i], L[i + 1])
  echo ans
  return

#{{{ input part
block:
  N = nextInt()
  L = newSeqWith(2*N, nextInt())
  solve()
#}}}
