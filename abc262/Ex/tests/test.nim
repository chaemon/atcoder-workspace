import ../main

import random

for _ in 0 .. 100:
  var
    N = 4
    M = 4
    Q = 5
    L, R, X = newSeq[int](Q)
  for i in 0..<Q:
    L[i] = random.rand(0..<N)
    R[i] = random.rand(0..<N)
    if L[i] > R[i]: swap L[i], R[i]
    R[i].inc
    X[i] = random.rand(1..M)
  echo "test for", N, M, Q, L, R, X
  test(N, M, Q, L, R, X)

