when defined SecondCompile:
  const
    DO_CHECK = false
    DEBUG = false
else:
  const
    DO_CHECK = true
    DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/binary_search
import atcoder/lazysegtree

type S = tuple[x, i:int]
type F = tuple[a, b:int]

proc op(a, b:S):S = discard #dummy
proc e():S = (0, 0)
proc mapping(f: F, s: S):S =
  result.i = s.i
  result.x = s.x + f.a * s.i + f.b
proc composition(f, g:F):F =
  (f.a + g.a, f.b + g.b)
proc id():F = (0, 0)

solveProc solve(N:int, p:seq[int]):
  var st = initLazySegTree[S, F](N, op, e, mapping, composition, id)
  for i in N:
    st[i] = (0, i)
  let M = N div 2
  for j in N:
    let i = p[j]
    # 料理iについて今jの目の前にある
    # t個回すとj + tの目の前に
    var t = (i - j).floorMod N
    # t - iにiを足す
    # x = t - iでax + b = i
    # つまり-x+tを足す
    # x = t - i + Nの場合
    # i = ax + b = -x + N + t
    block:
      var
        l = t - M
        r = t
      if l < 0:
        st.apply(l + N ..< N, (-1, N + t))
        st.apply(0 ..< r, (-1, t))
      else:
        st.apply(l ..< r, (-1, t))
    # t + iにiを足す
    # x = t + iでax + b = i
    # つまりx - tを足す
    # x = t + i - Nのときは
    # x + N - tを足す
    block:
      var
        l = t
        r = t - M + N
      if r > N:
        st.apply(l ..< N, (1, -t))
        st.apply(0 ..< r - N, (1, N - t))
      else:
        st.apply(l ..< r, (1, -t))
  ans := int.inf
  for i in N:
    ans.min=st[i].x
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var p = newSeqWith(N, nextInt())
  solve(N, p)
else:
  discard

