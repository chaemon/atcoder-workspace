const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination
import atcoder/convolution
import deques

solveProc solve(N:int, M:int, K:int, A:seq[int]):
  var ans:mint
  if K == 0:
    # N + M - 1個からM * 2 - 1個選ぶ
    ans = mint.C(N + M - 1, M * 2 - 1)
  else:
    var q = initDeque[seq[mint]]()
    # A[0]までの決定
    block:
      let a = collect(newSeq):
        for j in 0 .. A[0]:
          mint.C(A[0] + j, j * 2)
      q.addLast a
    for i in 0 ..< K - 1:
      # A[i]からA[i + 1]の決定
      let d = A[i + 1] - A[i] - 1
      let a = collect(newSeq):
        for j in 0..d:
          # j人が新たに座る
          mint.C(d + j + 1, j * 2 + 1)
      q.addLast a
    # A[K - 1] .. ^1の決定
    let a = collect(newSeq):
      let d = N - 1 - A[K - 1]
      for j in 0 .. d:
        mint.C(d + j, j * 2)
    q.addLast a
    while q.len >= 2:
      q.addLast(convolution(q.popFirst, q.popFirst))
    ans = q.popFirst[M - K]
  ans *= mint.fact(M - K)
  echo ans
  return


when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt() - 1)
  solve(N, M, K, A)
else:
  discard

