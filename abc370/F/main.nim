when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/binary_search

solveProc solve(N:int, K:int, A:seq[int]):
  proc calc(W:int):seq[int] = # iから始めてW以上になるのにインデックスをいくつ動かすかをしゃくとり法で求める
    var
      s = 0
      j = 0
    for i in N:
      while s < W:
        s += A[j mod N]
        j.inc
      # i ..< jまで足すとW以上になる
      doAssert s >= W
      #debug i, j, W
      result.add j - i
      s -= A[i]
  proc merge(a, b:seq[int]):seq[int] =
    result = newSeq[int](a.len)
    for i in N:
      var j = i + a[i]
      result[i] = a[i] + b[j mod N]
  proc hop(a:seq[int], k:int):seq[int] =
    if k == 0:
      return newSeqWith(a.len, 0)
    result = a.hop(k div 2)
    result = merge(result, result)
    if k mod 2 == 1:
      result = merge(result, a)
  proc f(W:int):bool =
    var u = calc(W).hop(K)
    # Wずつ動かしたときにNが存在するか
    for i in u.len:
      if u[i] <= N: return true
    return false
  let
    W = f.maxRight(0 .. A.sum)
    u = calc(W).hop(K)
  var t = 0
  for i in N:
    if u[i] > N: t.inc
  echo W, " ", t
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

