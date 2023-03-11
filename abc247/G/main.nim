const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/mincostflow

const
  SZ = 150
  INF = 3 * 10^13 + 1

solveProc solve(N:int, A:seq[int], B:seq[int], C:seq[int]):
  var g = initMinCostFlow[int, int](SZ + SZ + 2)
  let
    s = SZ * 2
    t = s + 1
  for i in N:
    g.addEdge(A[i], B[i] + SZ, 1, INF - C[i])
  for i in SZ:
    g.addEdge(s, i, 1, 0)
    g.addEdge(i + SZ, t, 1, 0)
  let
    a = g.slope(s, t)
  var
    tb = initTable[int, int]()
  for i in 0 .. a.len - 2:
    let
      (lcap, lcost) = a[i]
      (rcap, rcost) = a[i + 1]
    doAssert (rcost - lcost) mod (rcap - lcap) == 0
    let
      slope = (rcost - lcost) div (rcap - lcap)
    for j in lcap..rcap:
      let d = j - lcap
      tb[j] = INF * j - (lcost + d * slope)
  var
    i = 1
    ans = Seq[int]
  while i in tb:
    ans.add tb[i]
    i.inc
  echo ans.len
  echo ans.join("\n")
  discard

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
  solve(N, A.pred, B.pred, C)
else:
  discard

