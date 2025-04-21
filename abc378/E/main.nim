when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree

solveProc solve(N:int, M:int, A:seq[int]):
  var
    s = 0
    ans = 0
  type S = tuple[n, s:int]
  var
    st = initSegTree[S](M, (a, b:S)=>(a.n + b.n, a.s + b.s), ()=>(0, 0))
  st[0] = (1, 0)
  s = 0
  for i in N:
    s += A[i]
    s.mod= M
    var
      p = st[0 ..< s]
      q = st[s + 1 .. ^1]
    ans += s * p.n - p.s
    ans += s * q.n - q.s + M * q.n
    block:
      var p = st[s]
      p.n.inc
      p.s += s
      st[s] = p
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

