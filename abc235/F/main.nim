const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils
import lib/math/combination

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:string, M:int, C:seq[int]):
  proc calc(b:int, d:int):tuple[n, s:mint] =
    a := newSeq[int]()
    for c in C:
      if b[c] == 0: a.add c
    # aに属する数がすべて含むn桁の数と和(最初の0を含める)
    n := mint(0)
    s := mint(0)
    ave := mint(a.sum) / a.len
    var ave_rest:mint
    if a.len < 10:
      ave_rest = mint(45 - a.sum) / (10 - a.len)
    for t in 0 .. a.len:
      # aのうちt個が出てこない
      # a.len - t個は出てくる
      n0 := mint.C(a.len, t) * mint(10 - t)^d
      ave_now := (ave * (a.len - t) + ave_rest * (10 - a.len)) / (10 - t)
      # 平均は常に出てくる数の平均 
      s0 := (mint(10)^d - 1) / 9 * ave_now * n0
      if t mod 2 == 0:
        n += n0
        s += s0
      else:
        n -= n0
        s -= s0
    return (n, s)
  ans := mint(0)
  b := 0
  s0 := mint(0)
  For i := 0, i < N.len, i.inc:
    let d = N[i].ord - '0'.ord
    # 追従
    block:
      start := 0
      if i == 0:
        start = 1
      for t in start ..< d:
        let (n, s) = calc(b or [t], N.len - 1 - i)
        ans += s + n * (s0 * 10 + t) * mint(10)^(N.len - 1 - i)
    # 0 padding
    if i > 0:
      for t in 1 .. 9:
        let (n, s) = calc(0 or [t], N.len - 1 - i)
        ans += s + n * t * mint(10)^(N.len - 1 - i)
    b.or= [d]
    s0 *= 10
    s0 += d
  block:
    # 全部追従で条件を満たすなら足す
    ok := true
    for c in C:
      if b[c] == 0: ok = false
    if ok: ans += s0
  echo ans
  discard


when not DO_TEST:
  block:
    var N = nextString()
    var M = nextInt()
    var C = newSeqWith(M, nextInt())
    solve(N, M, C)
else:
  discard
