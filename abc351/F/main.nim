when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree

type S = tuple[s, n:int]

proc op(a, b:S):S = (a.s + b.s, a.n + b.n)
proc e():S = (0, 0)

solveProc solve(N:int, A:seq[int]):
  var c = A.toSeq.sorted
  c = c.deduplicate(isSorted = true)
  var
    st = initSegTree[S](A.len, op, e)
    ans = 0
  for i in N:
    let
      ai = c.lowerBound(A[i])
      (s, n) = st[0 ..< ai]
    ans += n * A[i] - s
    block:
      let (s, n) = st[ai]
      st[ai] = (s + A[i], n + 1)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

