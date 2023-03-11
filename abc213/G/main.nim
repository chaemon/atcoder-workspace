const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include lib/header/chaemon_header
import
  std/bitops, 
  lib/other/bitutils

import atcoder/modint
const MOD = 998244353
type mint = modint998244353

solveProc solve(N:int, M:int, a:seq[int], b:seq[int]):
  # f:connected, g:any graph
  var f, g = Seq[2^N: mint]
  let B = (1 shl N) - 1
  for S in 2^N:
    g[S] = mint(1)
    for i in M:
      if not S[a[i]] or not S[b[i]]: continue
      g[S] *= 2
    f[S] = g[S]
    if S == 0: continue
    var v = @S
    let i0 = v.pop
    for T in subsets(v):
      let T = T xor [i0]
      if T == S: continue
      f[S] -= f[T] * g[S xor T]
  for k in 1..<N:
    var ans = mint(0)
    for T in 2^N:
      if not T[0] or not T[k]: continue
      ans += f[T] * g[B xor T]
    echo ans
  return

when not DO_TEST:
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, 0)
  var b = newSeqWith(M, 0)
  for i in 0..<M:
    a[i] = nextInt() - 1
    b[i] = nextInt() - 1
  solve(N, M, a, b)

