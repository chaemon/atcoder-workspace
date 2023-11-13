when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const B = 62

solveProc solve(N:int, A:seq[int]):
  var dp = Seq[A[0], A[1], A[2], 2, 2, 2: mint(0)] # 余り, 追従しているかどうか
  dp[0][0][0][1][1][1] = 1
  for d in countdown(B, 0):
    var dp2 = Seq[A[0], A[1], A[2], 2, 2, 2: mint(0)] # 余り, 追従しているかどうか
    for r0 in A[0]:
      for b0 in 2:
        for d0 in 2:
          if b0 == 1 and N[d] == 0 and d0 == 1: continue
          let
            s0 = ((1 shl d) * d0 + r0) mod A[0]
            c0 = (if b0 == 1 and N[d] == 1 and d0 == 0: 0 else: b0)
          for r1 in A[1]:
            for b1 in 2:
              for d1 in 2:
                if b1 == 1 and N[d] == 0 and d1 == 1: continue
                let
                  s1 = ((1 shl d) * d1 + r1) mod A[1]
                  c1 = (if b1 == 1 and N[d] == 1 and d1 == 0: 0 else: b1)
                for r2 in A[2]:
                  for b2 in 2:
                    for d2 in 2:
                      if b2 == 1 and N[d] == 0 and d2 == 1: continue
                      let
                        s2 = ((1 shl d) * d2 + r2) mod A[2]
                        c2 = (if b2 == 1 and N[d] == 1 and d2 == 0: 0 else: b2)
                      if (d0 xor d1 xor d2) != 0: continue
                      if dp[r0][r1][r2][b0][b1][b2] == 0: continue
                      dp2[s0][s1][s2][c0][c1][c2] += dp[r0][r1][r2][b0][b1][b2]
    dp = dp2.move
  var ans = mint(0)
  for b0 in 2:
    for b1 in 2:
      for b2 in 2:
        ans += dp[0][0][0][b0][b1][b2]
  # (0, 0, 0)を除く
  ans.dec
  # {0, n, n}系を除く
  for i in 3:
    let
      j = (i + 1) mod 3
      k = (j + 1) mod 3
    let
      G = gcd(A[j], A[k])
      L = (A[j] * A[k]) div G
    ans -= (N div L)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(3, nextInt())
  solve(N, A)
else:
  discard

