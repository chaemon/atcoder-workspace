when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, X:int, A:seq[int], P:seq[int], B:seq[int], Q:seq[int]):
  var (A, P, B, Q) = (A, P, B, Q)
  for i in N:
    # 機械S[i]を1つ減らすことを考える
    # x * A[i] + y * B[i] <= Wにおいて
    # xをB[i]減らして, yをA[i]増やす
    # 価格の増分
    # - P[i] * B[i] + Q[i] * A[i] <= 0であればよい
    if - P[i] * B[i] + Q[i] * A[i] > 0:
      swap A[i], B[i]
      swap P[i], Q[i]
  # 以降x <= B[i]としてよい
  proc f(W:int):bool =
    # S[i]をx個, T[i]をy個買う
    # min x * P[i] + y + Q[i]
    # s.t. x * A[i] + y * B[i] >= W
    # x < B[i], y < A[i]を全部網羅したい
    var s = 0
    for i in N:
      #debug A[i], P[i], B[i], Q[i]
      var m = int.inf
      for x in 0 ..< B[i]:
        var
          u = W - x * A[i]
          p = x * P[i]
          y = if u >= 0:
            u.ceilDiv(B[i])
          else:
            0
        p += y * Q[i]
        #debug i, x, y, p
        m.min=p
      #debug i, m
      s += m
    return s <= X
  echo f.maxRight(0 .. 10^10)
  discard

# W = 10^10で大丈夫か？つまりf(10^10) = falseか？

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  var A = newSeqWith(N, 0)
  var P = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var Q = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    P[i] = nextInt()
    B[i] = nextInt()
    Q[i] = nextInt()
  solve(N, X, A, P, B, Q)
else:
  discard

