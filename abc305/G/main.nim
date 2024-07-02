when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import lib/math/matrix
import lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, s:seq[string]):
  proc is_ok(S:string):bool =
    for j in M:
      for i in S.len:
        # i ..< i + s[j].lenについて
        let i2 = i + s[j].len
        if i2 > S.len: break
        if S[i ..< i2] == s[j]: return false
    return true
  proc toStr(b, n:int):string =
    result = ""
    for i in n:
      result.add if b[i] == 0: 'a' else: 'b'
  if N < 6:
    ans := 0
    for b in 2^N:
      if is_ok(toStr(b, N)): ans.inc
    echo ans;return
  type MT = DynamicMatrixType(mint)
  var
    A = MT.init(2^6)
    v = MT.initVector(2^6)
  for b in 2^6:
    var s = toStr(b, 6)
    if not s.is_ok: continue
    v[b] += 1
    for d in 0 .. 1:
      var
        b2 = b shr 1
      b2[6 - 1] = d
      if not toStr(b2, 6).isOK: continue
      A[b2, b] += 1
  v = A^(N - 6) * v
  echo v.sum
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var s = newSeqWith(M, nextString())
  solve(N, M, s)
else:
  discard

