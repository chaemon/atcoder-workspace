when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, X:int, U:seq[int], D:seq[int]):
  var Hmax = int.inf
  for i in N:
    Hmax.min=U[i] + D[i]
  proc f(H:int):bool = # Hの最小値
    proc get_range(U, D:int):tuple[l, r:int] =
      var
        l = 0
        r = U
      l.max= H - D
      r.min= H
      return (l, r)
    # ul +  <= U[i]
    # ur +  <= 
    # U[i] + D[i] <=
    var
      (l, r) = get_range(U[0], D[0])
    if l > r: return false
    for i in 1 ..< N:
      l -= X
      r += X
      var (l1, r1) = get_range(U[i], D[i])
      l.max= l1
      r.min= r1
      if l > r: return false
    return true
  let H = f.maxRight(0 .. Hmax)
  var ans = 0
  for i in N:
    ans += U[i] + D[i] - H
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var U = newSeqWith(N, 0)
  var D = newSeqWith(N, 0)
  for i in 0..<N:
    U[i] = nextInt()
    D[i] = nextInt()
  solve(N, X, U, D)
else:
  discard

