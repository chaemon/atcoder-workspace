when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree

var K0:int
type S = seq[int]
proc op(a, b:S):S {.inline.} =
  result = a
  for i in K0: result[i] += b[i]
proc e():S {.inline.} = Seq[K0: 0]

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, K:int, A:seq[int], Q:int, l:seq[int], r:seq[int]):
  Pred l
  K0 = K
  var st = initSegTree[S](N, op, e)
  for i in N:
    var a = e()
    a[i mod K] += A[i]
    st[i] = a
  for i in Q:
    var a = st[l[i] ..< r[i]]
    if a.allIt(it == a[0]):
      echo YES
    else:
      echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  var Q = nextInt()
  var l = newSeqWith(Q, 0)
  var r = newSeqWith(Q, 0)
  for i in 0..<Q:
    l[i] = nextInt()
    r[i] = nextInt()
  solve(N, K, A, Q, l, r)
else:
  discard

