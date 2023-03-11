const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/math

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

import lib/other/bitutils

solveProc solve(N:int):
  ans := mint(1) # 空集合
  d := mint(2)^N # 1個の場合
  ans += d
  for k in 2 .. N + 1:
    # k - 1個からk個
    # 1個付け加えることを考える
    # k - 1個の集合で奇数個の部分集合は2^(k - 2)個
    # これらのxorは全部異なる
    # 最後の一個はこれ以外
    d *= mint(2)^N - mint(2)^(k - 2)
    d /= k
    ans += d
  echo ans
  Naive:
    var dp = Seq[2, 2^N: mint(0)] # 個数 xor
    ans := 0
    for b in 2^(2^N):
      s := 0
      for i in 2^N:
        if b[i] == 1:
          s.xor=i
      if s != 0 or b.popCount mod 2 == 1: ans.inc
    echo ans + 1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  for N in 2..4:
    debug "test for ", N
    test(N)
  discard

