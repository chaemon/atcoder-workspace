when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree

proc op(a, b:int):int = max(a, b)
proc e():int = -int.inf

solveProc solve(N:int, A:seq[int], D:int, L:seq[int], R:seq[int]):
  Pred L
  var st = initSegTree[int](N, op, e)
  for i in N:
    st[i] = A[i]
  for i in D:
    echo max(st[0 ..< L[i]], st[R[i] .. ^1])
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var D = nextInt()
  var L = newSeqWith(D, 0)
  var R = newSeqWith(D, 0)
  for i in 0..<D:
    L[i] = nextInt()
    R[i] = nextInt()
  solve(N, A, D, L, R)
else:
  discard

