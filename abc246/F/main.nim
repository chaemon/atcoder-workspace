const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, L:int, S:seq[string]):
  s := Seq[N: 0]
  for i in N:
    for j in S[i].len:
      s[i][S[i][j].ord - 'a'.ord] = 1
  ans := mint(0)
  for b in 1 ..< 2^N:
    t := 2^26 - 1
    for i in N:
      if b[i] == 1:
        t.and= s[i]
    if b.popCount mod 2 == 1:
      ans += mint(t.popCount)^L
    else:
      ans -= mint(t.popCount)^L
  echo ans
  discard

when not DO_TEST:
  var N = nextInt()
  var L = nextInt()
  var S = newSeqWith(N, nextString())
  solve(N, L, S)
else:
  discard

