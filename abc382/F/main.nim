when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/lazysegtree


var H0:int

type ST = LazySegTreeType[int, int]((a, b:int)=>min(a, b), ()=>H0, (a, b:int)=>min(a, b), (f:int, s:int)=>min(f, s), ()=>H0)

solveProc solve(H:int, W:int, N:int, R:seq[int], C:seq[int], L:seq[int]):
  H0 = H
  Pred R, C
  var st = ST.init(W)
  # R[i]の大きい順
  var
    v:seq[tuple[R, i:int]]
    ans = Seq[N: int]
  for i in N:
    v.add (R[i], i)

  v.sort(SortOrder.Descending)
  for (R, i) in v:
    var h = st.prod(C[i] ..< C[i] + L[i]) - 1
    ans[i] = h + 1
    st.apply(C[i] ..< C[i] + L[i], h)
  echo ans.join("\n")

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var N = nextInt()
  var R = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  var L = newSeqWith(N, 0)
  for i in 0..<N:
    R[i] = nextInt()
    C[i] = nextInt()
    L[i] = nextInt()
  solve(H, W, N, R, C, L)
else:
  discard

