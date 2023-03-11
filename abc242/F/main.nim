const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, B:int, W:int):
  proc calc(T:int):seq[seq[mint]] =
    result = Seq[N + 1, M + 1: mint]
    for h in 0..N:
      for w in 0..M:
        s := mint(0)
        for i in 0..h:
          for j in 0..w:
            let d = mint.C(h, h - i) * mint.C(w, w - j) * mint.C((h - i) * (w - j), T)
            if (i + j) mod 2 == 0:
              s += d
            else:
              s -= d
        result[h][w] = s
  var
    a = calc(B)
    b = calc(W)
    ans = mint(0)
  for h0 in 0..N:
    for h1 in 0..N:
      if h0 + h1 > N: continue
      for w0 in 0..M:
        for w1 in 0..M:
          if w0 + w1 > M: continue
          ans += mint.C(N, h0) * mint.C(N - h0, h1) * mint.C(M, w0) * mint.C(M - w0, w1) * a[h0][w0] * b[h1][w1]
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var B = nextInt()
  var W = nextInt()
  solve(N, M, B, W)
else:
  discard

