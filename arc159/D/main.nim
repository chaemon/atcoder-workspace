when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree

type S = tuple[a, b:int]

op(a, b:S) => (max(a.a, b.a), min(a.b, b.b))
e() => (-int.inf, int.inf)


solveProc solve(N:int, l:seq[int], r:seq[int]):
  var x = @[0]
  for i in N:
    x.add r[i]
  x.sort
  x = x.deduplicate(isSorted = true)
  var
    st = initSegTree[S](x.len, op, e)
    ans0 = -int.inf

  st[0] = (0, 1)
  for i in N:
    # l[i] .. r[i]を追加
    let
      ri = x.lowerBound(r[i])
      j = x.lowerBound(l[i])
    # 0 ..< jの最大値をとる
    var ans = r[i] - l[i] + 1
    ans.max=st[0 ..< j].a + r[i] - l[i] + 1
    ans.max=r[i] - st[j .. ri].b + 1
    st[ri] = op(st[ri], (ans, ri - ans + 1))
    ans0.max= ans
  echo ans0
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var l = newSeqWith(N, 0)
  var r = newSeqWith(N, 0)
  for i in 0..<N:
    l[i] = nextInt()
    r[i] = nextInt()
  solve(N, l, r)
else:
  discard

