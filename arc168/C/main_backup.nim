when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/math/combination

var cmb = Combination[mint]()

solveProc solve(N:int, K:int, S:string):
  let
    A = S.count('A')
    B = S.count('B')
    C = S.count('C')
  var ans = mint(0)
  for AB in 0 .. K:
    for AC in 0 .. K:
      if AB + AC > K: continue
      for BA in 0 .. K:
        for BC in 0 .. K:
          if BA + BC > K: continue
          # CA, CBを決める
          let
            CA = AB + AC - BA
            CB = BA + BC - AB
          if CA < 0 or CB < 0 or CA + CB > K: continue
          let ok = block:
            shadow AB, AC, BA, BC, CA, CB
            let k = min(AB, BA)
            AB -= k
            BA -= k
            let l = min(AC, CA)
            AC -= l
            CA -= l
            let m = min(BC, CB)
            BC -= m
            CB -= m
            let n = AB
            doAssert BC == n and CA == n
            let o = BA
            doAssert AC == o and CB == o
            if k + l + m + 2 * (n + o) <= K:
              true
            else:
              false
          if not ok: continue
          debug AB, AC, BA, BC, CA, CB
          debug mint.C(A, AB), mint.C(A - AB, AC)
          debug mint.C(B, BA), mint.C(B - BA, BC)
          debug mint.C(C, CA), mint.C(C - CA, CB)

          ans += mint.C(A, AB) * mint.C(A - AB, AC) * mint.C(B, BA) * mint.C(B - BA, BC) * mint.C(C, CA) * mint.C(C - CA, CB)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var S = nextString()
  solve(N, K, S)
else:
  discard

