include atcoder/extra/header/chaemon_header

#import atcoder/extra/dp/dual_cumulative_sum_2d
import atcoder/segtree

import sequtils

var data: array[5050, array[5050, int]]
# DualCumulativeSum2D(imos) {{{
type DualCumulativeSum2D*[T] = object
  H, W:int
  built: bool
#  data: seq[seq[T]]

proc initDualCumulativeSum2D*[T](W, H:int):DualCumulativeSum2D[T] =
#  DualCumulativeSum2D[T](H:H, W:W, data: newSeqWith(W + 1, newSeqWith(H + 1, T(0))), built:false)
  DualCumulativeSum2D[T](H:H, W:W, built:false)
#proc initDualCumulativeSum2D[T](data:seq[seq[T]]):CumulativeSum2D[T] =
#  result = initCumulativeSum2D[T](data.len, data[0].len)
#  for i in 0..<data.len:
#    for j in 0..<data[i].len:
#      result.add(i,j,data[i][j])
#  result.build()

proc add*[T](self:var DualCumulativeSum2D[T]; rx, ry:Slice[int], z:T) =
  assert not self.built
  let (gx, gy) = (rx.b + 1, ry.b + 1)
  let (sx, sy) = (rx.a, ry.a)
  data[gx][gy] += z
  data[sx][gy] -= z
  data[gx][sy] -= z
  data[sx][sy] += z

proc build*[T](self:var DualCumulativeSum2D[T]) =
  self.built = true
  for i in 1..<data.len:
    for j in 0..<data[0].len:
      data[i][j] += data[i - 1][j]
  for j in 1..<data[0].len:
    for i in 0..<data.len:
      data[i][j] += data[i][j - 1]

proc `[]`*[T](self: DualCumulativeSum2D[T], x, y:int):T =
  assert(self.built)
#  let (x, y) = (x + 1, y + 1)
  if x >= data.len or y >= data[0].len: return T(0)
  return data[x][y]

proc write*[T](self: DualCumulativeSum2D[T]) =
  assert(self.built)
  for i in 0..<self.H:
    for j in 0..<self.W:
      stdout.write(self[i,j])
    echo ""
#}}}

var cs = initDualCumulativeSum2D[int](5010, 5010)

proc solve(N:int, M:int, A:seq[int], B:seq[seq[int]]) =
  let N = N
  var v = -int.inf
  proc calc(st:segTree, i, j:int) =
    if i + 1 >= j: return
    v = st.prod(i..<j)
    let k = st.max_right(i, (f:int) => f < v)
    assert k in i..<j
    cs.add(i..k, k..<j, v)
    st.calc(i, k)
    st.calc(k + 1, j)

    discard

  var st = initSegTree(N, (a:int, b:int) => max(a, b), () => -int.inf)
  for j in 0..<M:
    for i in 0..<N:st.set(i, B[i][j])
    st.calc(0, N)
  cs.build()
  var ans = -int.inf
  for i in 0..<N:
    var s = 0
    for j in i..<N:
      ans.max= cs[i, j] - s
      s += A[j]
  echo ans
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N-1, nextInt())
  var B = newSeqWith(N, newSeqWith(M, nextInt()))
  solve(N, M, A, B)
#}}}
