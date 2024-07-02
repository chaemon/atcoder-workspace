when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/structure/set_map

solveProc solve(N:int, Q:int, A:seq[int], ik:seq[int], x:seq[int]):
  var
    a = Seq[N + 5: 0]
    z = initSortedSet[int]()
    A = A
  for i in a.len:
    z.insert i
  proc add(x:int) =
    if x >= a.len: return
    if a[x] == 0:
      z.erase(x)
    a[x].inc
  proc remove(x:int) =
    if x >= a.len: return
    doAssert a[x] > 0
    a[x].dec
    if a[x] == 0:
      z.insert(x)
  for i in N:
    add(A[i])

  for q in Q:
    var
      i = ik[q]
      x = x[q]
    i.dec
    remove(A[i])
    A[i] = x
    add(A[i])
    echo *z.begin()

  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var ik = newSeqWith(Q, 0)
  var x = newSeqWith(Q, 0)
  for i in 0..<Q:
    ik[i] = nextInt()
    x[i] = nextInt()
  solve(N, Q, A, ik, x)
else:
  discard

