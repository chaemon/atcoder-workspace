when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/lazysegtree

op(a, b:int) => a + b
e() => 0
mapping(f, s:int) => f + s
composition(f1, f2:int) => f1 + f2
id() => 0

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  var st = initLazySegTree[int, int](N * 2, op, e, mapping, composition, id)
  for i in N:
    st[i] = A[i]
  for i in M:
    let S = st[B[i]] + st[B[i] + N]
    st[B[i]] = 0
    st[B[i] + N] = 0
    let
      q = S div N
      r = S mod N
    st.apply(B[i] + 1 .. B[i] + N, q)
    st.apply(B[i] + 1 .. B[i] + r, 1)
  var ans = Seq[int]
  for i in N:
    ans.add st[i] + st[i + N]
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  solve(N, M, A, B)
else:
  discard

