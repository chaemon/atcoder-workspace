when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, A:seq[int]):
  proc calc(b, m:int):int =
    # bから3人組を4つ作場合の最大値。ただし、m以上じゃないとだめ
    var ans = int.inf
    proc calcImpl(b, t, M:int) =
      if t == N - 1:
        ans.min=M; return
      var v:seq[int]
      for i in 3 * N:
        if b[i] == 0: v.add i
      for j in 1 ..< v.len:
        for k in j + 1 ..< v.len:
          # 0, j, k
          let S = A[v[0]] + A[v[j]] + A[v[k]]
          if S < m: continue
          calcImpl(b xor [v[0]] xor [v[j]] xor [v[k]], t + 1, max(M, S))
    calcImpl(b, 0, -int.inf)
    return ans
  var ans = int.inf
  for i in 3 * N:
    for j in i + 1 ..< 3 * N:
      for k in j + 1 ..< 3 * N:
        let
          b = (1 shl i) xor (1 shl j) xor (1 shl k)
          m = A[i] + A[j] + A[k]
        let M = calc(b, m)
        ans.min= M - m
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(3*N, nextInt())
  solve(N, A)
else:
  discard

