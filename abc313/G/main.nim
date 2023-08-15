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

import atcoder/math

solveProc solve(N:int, a:seq[int]):
  var
    a = a.sorted
    i = 0
    s = 0
    ans = mint(0)
  let m = a[0]
  for j in N:
    a[j] -= m
    s += m
  while i < a.len:
    var j = i
    while j < a.len and a[i] == a[j]:
      j.inc
    # a[i] <= k < a[j]について
    # d = k - a[i]として
    # s + (N - j) * d個をN個ずつに分割
    # つまり
    # [(s + (N - j) * d) / N] + 1の和
    #
    #
    # (3, 1, 3)の場合(最初s = 3)
    # (0, 2, 2)系列: (0, 2, 2), (1, 3, 3)
    # (0, 1, 1)系列: (0, 1, 1), (1, 2, 2)
    # 
    # (0, 0, 0)系列: (0, 0, 0), (1, 1, 1), (2, 2, 2)
    if j < a.len:
      let n = a[j] - a[i]
      ans += floor_sum(n, N, N - j, s) + n
      s += n * (N - j)
    else:
      ans += (s div N) + 1
    i = j
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  discard

