const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header
import complex

solveProc solve(N:int, X:seq[int], Y:seq[int]):
  var
    P = Seq[N: Complex[float]]
    ans = -float.inf
  for i in N:
    P[i] = complex(X[i], Y[i])
  for i in N:
    var v = Seq[float]
    for j in N:
      if i == j: continue
      v.add phase(P[j] - P[i])
    v.sort()
    let L = v.len
    w := v
    for p in w.mitems: p += PI * 2.0
    v = v & w
    for i in L:
      # v[i] + PIに近い値を探す
      var k = v.lowerBound(v[i] + PI)
      if k != v.len:
        ans.max= 2.0 * PI - (v[k] - v[i])
      if k - 1 != i:
        ans.max= v[k - 1] - v[i]
  echo ans / (PI) * 180.0
  return

# input part {{{
when not DO_TEST:
  var N = nextInt()
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  for i in 0..<N:
    X[i] = nextInt()
    Y[i] = nextInt()
  solve(N, X, Y)
#}}}

