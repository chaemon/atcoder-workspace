const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/dsu

solveProc solve(N:int, M:int, A:seq[int], B:seq[int], C:seq[int]):
  var
    v = Seq[tuple[C, A, B:int]]
    s = 0
  for i in M:
    v.add((C[i], A[i], B[i]))
    s += C[i]
  v.sort()
  dsu2 := initDSU(N)
  for i in M:
    let (C, A, B) = v[i]
    if dsu2.leader(A) != dsu2.leader(B):
      dsu2.merge(A, B)
      s -= C
  echo s
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(M, 0)
  var B = newSeqWith(M, 0)
  var C = newSeqWith(M, 0)
  for i in 0..<M:
    A[i] = nextInt() - 1
    B[i] = nextInt() - 1
    C[i] = nextInt()
  solve(N, M, A, B, C)
else:
  discard

