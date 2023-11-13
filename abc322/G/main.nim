when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

const AMAX = 21
# a > b

solveProc solve(N:int, X:int):
  ans := mint(0)
  # AMAX >= a > bの場合
  for a in 3 .. min(N, AMAX):
    for b in 2 ..< a:
      let D = min([10, a, b])
      var
        pa = 1
        pb = 1
        v:seq[int]
      while true:
        pa *= a
        pb *= b
        if pa - pb > X: break
        v.add pa - pb
      var
        X2 = X
        ok = true
        d:seq[int]
      for i in 0 ..< v.len << 1:
        let s = X2 div v[i]
        d.add s
        if s >= D:
          ok = false
          break
        X2 -= s * v[i]
      if X2 != 0: ok = false
      if not ok: continue
      # 1の位は0 ..< Dの何でも良い
      ans += D
  # 3 <= k <= 4の場合
  # 1の位はなんでもいい
  # Xは(a - b)で割り切れる
  for d in 1 .. X:
    if X mod d != 0: continue
    # a - b = d
    for S in 10 .. 999:
      # a - bを推測する。その上でbについて単調増加なので二分探索
      # a = b + dとする
      var S:seq[int] = block:
        var
          v:seq[int]
          S = S
        while S > 0:
          v.add S mod 10
          S.div=10
        v
      proc calc(b:int):int =
        let a = b + d
        var
          pa = 1
          pb = 1
          v:seq[int]
        while true:
          pa *= a
          pb *= b
          if pa - pb > X: break
          v.add pa - pb
        if S.len > v.len: return X + 1
        result = 0
        for i in S.len:
          result += S[i] * v[i]
        result.min= X + 1

      proc f(b:int):bool = # Xより小さいとfalse, 以上でtrue
        if b == 1: return false
        return calc(b) >= X

      let b = f.minLeft(1 .. X)
      if calc(b) != X: continue
      let a = b + d
      if a > N or a <= AMAX: continue
      var ok = true
      for i in S.len:
        if S[i] >= b: ok = false
      if not ok: continue
      # 1の位分足す
      ans += min([10, a, b])
      discard
  # k = 2の場合
  for d in 1 .. X:
    if X mod d != 0: continue
    let p = X div d
    # (p, *)という形になる。
    if p >= 10: continue
    # a > b > p
    # (a, b) = (b + d, b)の形が条件をみたすが、N >= b + d > AMAXとなるようなbの範囲を取る
    var
      bmax = N - d
      bmin = max(p + 1, AMAX + 1 - d)
    # bmin <= b <= bmaxならOKだが、足す値は10 <= bであれば10個、それ以外はb個
    for b in bmin .. min(9, bmax):
      ans += b
    if 10 <= bmax:
      ans += (bmax - 10 + 1) * 10
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var X = nextInt()
  solve(N, X)
else:
  discard

