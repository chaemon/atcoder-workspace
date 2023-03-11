const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree
import lib/other/compress
import lib/other/algorithmutils

proc disjoint(p, q:Slice[int]):bool = p.b < q.a or q.b < p.a
proc contains(p, q:Slice[int]):bool = q.a <= p.a and p.b <= q.b

var id_max = 0

type KDTreeNode[T, U] = ref object
  l, r:KDTreeNode[T, U]
  xmin, xmax, ymin, ymax, zmin, zmax: T
  size: int
  val: U
  id:int

type KDTree[T, U] = object
  root:KDTreeNode[T, U]

proc initKDTreeNode[T, U](v:var seq[(T, T, T)], i, j:int, d = 0):KDTreeNode[T, U] =
  type S = (T, T, T)
  #using T = pair<int, int>;
  #using Iter = vector<T>::iterator;
  var l, r: KDTreeNode[T, U]
  # 矩形クエリのために x / y 座標の最小値と最大値を持つ
  # 挿入・削除はないので、何の要素を持っているかは必要ない (要素を持っている葉と要素を持っていないそれ以外のノードを同じように扱える)

  var
    xmin = T.inf
    xmax = -T.inf
    ymin = T.inf
    ymax = -T.inf
    zmin = T.inf
    zmax = -T.inf
    size = j - i
    # vector<T> で渡してもいいですが、コピーコストがかかるので in-place に
  for (x, y, z) in v[i ..< j]:
    xmin.min=x
    xmax.max=x
    ymin.min=y
    ymax.max=y
    zmin.min=z
    zmax.max=z
  var id = id_max
  id_max.inc
  if size > 1:
    # 葉木なので x / y 座標で半分に分けて再帰
    let m = i + size div 2
    # 縦横交互に分ける
    if d == 0:
      v.nth_element(i, m, j, proc(a, b:S):bool = a[0] < b[0])
    elif d == 1:
      v.nth_element(i, m, j, proc(a, b:S):bool = a[1] < b[1])
    elif d == 2:
      v.nth_element(i, m, j, proc(a, b:S):bool = a[2] < b[2])

    var d2 = d + 1
    if d2 == 3: d2 = 0
    l = initKDTreeNode[T, U](v, i, m, d2)
    r = initKDTreeNode[T, U](v, m, j, d2)
  return KDTreeNode[T, U](l: l, r: r, xmin:xmin, xmax:xmax, ymin:ymin, ymax:ymax, zmin:zmin, zmax:zmax, val: -U.inf, id:id, size:size)

# [x1, x2] * [y1, y2] * [z1, z2] にある点の最大値を数える
proc query[T, U](self: KDTreeNode[T, U], x1, x2, y1, y2, z1, z2:int):auto =
  #if self == nil: return -int.inf
  # [xmin, xmax] * [ymin, ymax] と [x1, x2] * [y1, y2] に共通部分がない
  if disjoint(self.xmin .. self.xmax, x1 .. x2) or disjoint(self.ymin .. self.ymax, y1 .. y2) or disjoint(self.zmin .. self.zmax, z1 .. z2):
    return -int.inf
  # [xmin, xmax] * [ymin, ymax] 全体が [x1, x2] * [y1, y2] に含まれている
  if contains(self.xmin .. self.xmax, x1 .. x2) and contains(self.ymin .. self.ymax, y1 .. y2) and contains(self.zmin .. self.zmax, z1 .. z2):
    return self.val
  # [xmin, xmax] * [ymin, ymax] の一部が [x1, x2] * [y1, y2] に含まれている -> 子に任せる
  return max(self.l.query(x1, x2, y1, y2, z1, z2), self.r.query(x1, x2, y1, y2, z1, z2))

# [x1, x2] * [y1, y2] * [z1, z2] にある点の最大値を数える
proc set[T, U](self: var KDTreeNode[T, U], x, y, z:int, val:U) =
  if self == nil: return
  elif x notin self.xmin .. self.xmax or y notin self.ymin .. self.ymax or z notin self.zmin .. self.zmax:
    # (x, y, z)が[xmin, xmax] * [ymin, ymax] * [zmin, zmax]に含まれない
    return
  elif self.l == nil and self.r == nil:
    doAssert self.size == 1
    doAssert x == self.xmin and x == self.xmax
    doAssert y == self.ymin and y == self.ymax
    doAssert z == self.zmin and z == self.zmax
    self.val.max= val
  else:
    self.l.set(x, y, z, val)
    self.r.set(x, y, z, val)
    self.val = max(self.l.val, self.r.val)

solveProc solve(N:int, T:seq[int], X:seq[int], Y:seq[int], A:seq[int]):
  # T - Y - X, T - Y + X, Y
  var kdt = block:
    var v = Seq[tuple[x, y, z:int]]
    v.add (0, 0, 0)
    for i in N:
      v.add (T[i] - Y[i] - X[i], T[i] - Y[i] + X[i], Y[i])
    initKDTreeNode[int, int](v, 0, v.len)
  var v = collect(newSeq):
    for i in N: (T[i], i)
  v.sort
  ans := 0
  kdt.set(0, 0, 0, 0)
  for (t, i) in v:
    let (x, y, z) = (T[i] - Y[i] - X[i], T[i] - Y[i] + X[i], Y[i])
    let u = kdt.query(-int.inf, x, -int.inf, y, -int.inf, z)
    #debug u + A[i]
    ans.max= u + A[i]
    kdt.set(x, y, z, u + A[i])
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, 0)
  var X = newSeqWith(N, 0)
  var Y = newSeqWith(N, 0)
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextInt()
    X[i] = nextInt()
    Y[i] = nextInt()
    A[i] = nextInt()
  solve(N, T, X, Y, A)
else:
  discard

