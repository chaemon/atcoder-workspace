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

import lib/math/combination

import atcoder/dsu

solveProc solve(N:int, M:int, P:seq[int]):
  var
    dsu = initDSU(N)
    ct = 0 # 0 ..< iに何種類の値があるか? => いらない？
    rest = N # i ..< Nでまだ出てきていないのがいつくあるか
    ans = mint(0)
  for i in N:
    # A[i] < A[P[i]]にする
    if not dsu.same(i, P[i]): # 同一の木だったらだめ
      # そうでないとき、2つの成分は異なる
      let d = mint.C_large(M, 2) * mint(M)^(rest - 2)
      ans += d
      # A[i] = A[P[i]]にする
      dsu.merge(i, P[i])
      rest.dec
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var P = newSeqWith(N, nextInt()).pred
  solve(N, M, P)
else:
  discard

