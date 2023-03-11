const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int):
  echo mint(N)^M * mint(M)^(N - 1)
  Naive:
    var
      v = Seq[int]
      s = 0
    proc f() =
      if v.len == N:
        p := 1
        for i in M:
          c := 0
          for j in v.len:
            if v[j][i] == 1: c.inc
          p *= c
        s += p
      else:
        var b = v[^1]
        for i in M:
          v.add b xor [i]
          f()
          discard v.pop
    for b in 2^M:
      v.add b
      f()
      discard v.pop
    echo mint(s)
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  for N in 1..6:
    for M in 1..6:
      test(N, M)
      #debug N, M, solve_naive(N, M)
  discard

