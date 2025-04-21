when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(H:int, W:int, F:seq[seq[int]], Q:int, A:seq[int], B:seq[int], Y:seq[int], C:seq[int], D:seq[int], Z:seq[int]):
  Pred A, B, C, D
  var
    v = Seq[tuple[F, i, j:int]]
    d = initDSU(H * W)
    a = Seq[H * W: initTable[int, int]()]
    ans = Seq[Q: -1]
  proc id(i, j:int):int = i * W + j
  for i in H:
    for j in W:
      v.add (F[i][j], i, j)
  for i in Q:
    a[id(A[i], B[i])][i] = Y[i]
    a[id(C[i], D[i])][i] = Z[i]
  v.sort(Descending)
  proc merge(i, j, F:int) =
    var
      i = d.leader(i)
      j = d.leader(j)
    if i == j: return
    let m = d.merge(i, j)
    # mがleader
    if a[i].len < a[j].len:
      swap i, j
    # iにjをマージ
    for k, v in a[j]:
      if k in a[i]:
        # ansの決定
        if Y[k] >= F and Z[k] >= F:
          ans[k] = Y[k] - F + Z[k] - F
        else:
          ans[k] = abs(Y[k] - Z[k])
        a[i].del(k)
        a[j].del(k)
      else:
        a[i][k] = v
    if i != m:
      a[m] = a[i].move()
  for (F0, i, j) in v:
    for (di, dj) in [(0, 1), (1, 0), (0, -1), (-1, 0)]:
      let
        i2 = i + di
        j2 = j + dj
      if i2 notin 0 ..< H or j2 notin 0 ..< W: continue
      if F[i2][j2] >= F0:
        merge(id(i, j), id(i2, j2), F0)
  echo ans.join("\n")
  doAssert false
when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var F = newSeqWith(H, newSeqWith(W, nextInt()))
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  var Y = newSeqWith(Q, 0)
  var C = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  var Z = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
    Y[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
    Z[i] = nextInt()
  solve(H, W, F, Q, A, B, Y, C, D, Z)
else:
  discard

