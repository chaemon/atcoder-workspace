const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/segtree

# Failed to predict input format
solveProc solve(N, Q:int, A, B:seq[int]):
  var stA, stB = initSegTree[int](N - 1, (a, b:int)=>gcd(a, b), ()=>0)
  for i in N - 1:
    stA[i] = A[i + 1] - A[i]
    stB[i] = B[i + 1] - B[i]
  for _ in Q:
    var h1, h2, w1, w2 = nextInt() - 1
    echo gcd(gcd(A[h1] + B[w1], stA[h1..h2-1]), stB[w1..w2-1])
  discard

when not DO_TEST:
  let
    N, Q = nextInt()
    A = Seq[N: nextInt()]
    B = Seq[N: nextInt()]
  solve(N, Q, A, B)
else:
  discard

