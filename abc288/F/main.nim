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
solveProc solve(N:int, X:string):
  var
    s = mint(1)
    p = mint(0)
  # s: 切れた時点までの和
  # p: かけたもの
  # pはΣs_i * D_iの形となっている
  # pを10倍して
  # これにs = Σs_i * dを足す
  for i,d in X:
    let d = d - '0'
    s += p
    p = p * 10 + s * d
  echo p
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextString()
  solve(N, X)
else:
  discard

