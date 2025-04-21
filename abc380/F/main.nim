when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

import atcoder/extra/math/convert_base

solveProc solve(N:int, M:int, L:int, A:seq[int], B:seq[int], C:seq[int]):
  var
    a = A & B & C
    S = N + M + L
  var
    vis = Seq[3^S, 2: -1] # digit, turn, 勝敗(0: 高橋君, 1: 青木君)
  proc calc(d:int, t:int):int =
    if vis[d][t] != -1: return vis[d][t]
    var vi = d.toSeq(3, S)
    result = 0
    for i in S:
      if vi[i] == t:
        # vi[i]を出す
        block:
          # 何もとらない
          var vi2 = vi
          vi2[i] = 2
          if calc(vi2.toInt(3), t xor 1) == 0: result = 1
        for j in S:
          if vi[j] == 2 and a[i] > a[j]:
            var vi2 = vi
            vi2[i] = 2
            vi2[j] = t
            if calc(vi2.toInt(3), t xor 1) == 0: result = 1
    vis[d][t] = result
    #debug vis[d][t], d, t, vi
  var
    vi = 0.repeat(N) & 1.repeat(M) & 2.repeat(L)
    r = calc(vi.toInt(3), 0)
  if r == 1:
    echo "Takahashi"
  else:
    echo "Aoki"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var L = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(M, nextInt())
  var C = newSeqWith(L, nextInt())
  solve(N, M, L, A, B, C)
else:
  discard

