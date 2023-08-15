when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/graph/graph_template
import lib/other/bitset

const YES = "Yes"
const NO = "No"

const T = (1000.ceilDiv 64) * 64

solveProc solve(N:int, M:int, A:seq[int], B:seq[int]):
  Pred A, B
  var g = initGraph(N)
  for i in M:
    g.addBiEdge(A[i], B[i])
  var
    vis = N @ false
    parity = N @ 0
    a = Array[T: initBitSet[T]()]
  a[0][0] = 1
  proc dfs(u:int, p = -1, t = 0):(int, int) =
    if vis[u]: return
    vis[u] = true
    parity[u] = t
    let t2 = 1 - t
    var x, y = 0
    if t == 0: x.inc
    else: y.inc
    for e in g[u]:
      let
        v = e.dst
      if vis[v]:
        if parity[v] != t2:
          return (-1, -1)
      else:
        let (x2, y2) = dfs(v, u, t2)
        if x2 == -1:
          return (-1, -1)
        x += x2; y += y2
    return (x, y)
  for u in N:
    if vis[u]: continue
    let (x, y) = dfs(u)
    if x == -1: continue
    if x == 0 or y == 0:
      doAssert x + y == 1
      for r in 0 ..< T << 1:
        block:
          a[r] = a[r] or (a[r] shl 1)
          let r2 = r - 1
          if r2 >= 0:
            a[r] = a[r] or a[r2]
    else:
      # x個の1とy個の2またはy個の1とx個の2をもらうDPで
      for r in 0 ..< T << 1:
        block:
          let r2 = r - x
          if r2 >= 0:
            a[r] = a[r] or (a[r2] shl y)
        block:
          let r2 = r - y
          if r2 >= 0:
            a[r] = a[r] or (a[r2] shl x)
  var rs = Array[3: 0]
  for r in 1 .. N:
    rs[r mod 3].inc
  if a[rs[1]][rs[2]] == 1:
    echo YES
  else:
    echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, M, A, B)
else:
  discard

