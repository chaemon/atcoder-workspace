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

solveProc solve(N:int, D:int, A:seq[int]):
  const B = 5 * 10^5 + 10
  var st = initSegTree[int](B, op, e)
  st[A[0]] = 1
  for i in 1 ..< N:
    var
      l = max(A[i] - D, 0)
      r = min(A[i] + D, B - 1)
    # l .. r
    st[A[i]] = max(1, st[l .. r] + 1)
  echo st[0 .. ^1]
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var D = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, D, A)
else:
  discard

