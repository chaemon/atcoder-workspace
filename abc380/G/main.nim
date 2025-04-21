when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/segtree

import atcoder/modint
const MOD = 998244353
type mint = modint998244353
solveProc solve(N:int, K:int, P:seq[int]):
  Pred P
  var t = 0
  block:
    var
      st = initSegTree[int](N, (a, b:int)=>a+b, ()=>0)
    # 通常の転倒数を数える
    for i in N:
      t += st[P[i] .. ^1]
      st[P[i]] = 1
  var
    st = initSegTree[int](N, (a, b:int)=>a+b, ()=>0)
    U = mint((K * (K - 1)) div 2) / 2
    D = mint(1) / (N - K + 1)
    t2 = 0
    ans = mint(0)
  for i in K:
    t2 += st[P[i] .. ^1]
    st[P[i]] = 1
  for i in N - K + 1:
    # i ..< i + Kについての転倒数を数える
    #t個の転倒のうちt2個はチャラにする代わりに期待値でU個の転倒があり得る
    ans += D * (t - t2 + U)
    # t2の値の帳尻をあわせる
    if i == N - K: break
    # P[i]が抜けてP[i + K]が入る
    t2 -= st[0 ..< P[i]]
    st[P[i]] = 0
    t2 += st[P[i + K] .. ^1]
    st[P[i + K]] = 1
  echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, K, P)
else:
  discard

