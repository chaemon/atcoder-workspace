when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, Q:int, A:seq[int], B:seq[int], C:seq[int], D:seq[int]):
  for q in Q:
    let (A, B, C, D) = (A[q], B[q], C[q], D[q])
    ans := mint(0)
    # 奇数, 奇数
    block:
      var a = (A div 2) * 2 - 1
      while a < A: a += 2
      var b = (B div 2) * 2 + 1
      while b > B: b -= 2
      var c = (C div 2) * 2 - 1
      while c < C: c += 2
      var d = (D div 2) * 2 + 1
      while d > D: d -= 2
      var n = (b - a) div 2 + 1
      var m = (d - c) div 2 + 1
      var S = (a - 1) * M + c
      # S, S + 2 * M, S + 2 * M * 2, ..., 
      var T = mint(S + S + 2 * M * (n - 1)) * n / 2
      # T, T + 2 * n, T + 2 * n * 2, ...
      var U = (T + T + 2 * n * (m - 1)) * m / 2
      ans += U
    #
    # 偶数, 偶数
    block:
      var a = (A div 2) * 2
      while a < A: a += 2
      var b = (B div 2) * 2 + 2
      while b > B: b -= 2
      var c = (C div 2) * 2
      while c < C: c += 2
      var d = (D div 2) * 2 + 2
      while d > D: d -= 2
      var n = (b - a) div 2 + 1
      var m = (d - c) div 2 + 1
      var S = (a - 1) * M + c
      # S, S + 2 * M, S + 2 * M * 2, ..., 
      var T = mint(S + S + 2 * M * (n - 1)) * n / 2
      # T, T + 2 * n, T + 2 * n * 2, ...
      var U = (T + T + 2 * n * (m - 1)) * m / 2
      ans += U
    echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var Q = nextInt()
  var A = newSeqWith(Q, 0)
  var B = newSeqWith(Q, 0)
  var C = newSeqWith(Q, 0)
  var D = newSeqWith(Q, 0)
  for i in 0..<Q:
    A[i] = nextInt()
    B[i] = nextInt()
    C[i] = nextInt()
    D[i] = nextInt()
  solve(N, M, Q, A, B, C, D)
else:
  discard

