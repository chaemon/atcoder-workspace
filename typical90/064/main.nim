const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

solveProc solve(N:int, Q:int, A:seq[int], L:seq[int], R:seq[int], V:seq[int]):
  var
    d:seq[int]
    s = 0
  for i in N - 1:
    # d[i] = A[i + 1] - A[i]
    d.add A[i + 1] - A[i]
  for i in d.len:
    s += abs(d[i])
  Pred L, R
  for q in Q:
    # L[q] .. R[q]
    # d[L[q] - 1]がV[q]増える
    if L[q] > 0:
      s -= abs(d[L[q] - 1])
      d[L[q] - 1] += V[q]
      s += abs(d[L[q] - 1])
    # d[R[q]]がV[q]減る
    if R[q] < d.len:
      s -= abs(d[R[q]])
      d[R[q]] -= V[q]
      s += abs(d[R[q]])
    echo s
  doAssert false

  return

when not DO_TEST:
  var N = nextInt()
  var Q = nextInt()
  var A = newSeqWith(N, nextInt())
  var L = newSeqWith(Q, 0)
  var R = newSeqWith(Q, 0)
  var V = newSeqWith(Q, 0)
  for i in 0..<Q:
    L[i] = nextInt()
    R[i] = nextInt()
    V[i] = nextInt()
  solve(N, Q, A, L, R, V)
