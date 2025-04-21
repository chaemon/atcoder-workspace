when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false

include lib/header/chaemon_header
import atcoder/segtree
import std/sugar

solveProc solve(N:int, M:int, A:seq[int]):
  var
    a = Seq[M: seq[int]]
    st = initSegTree[int](M, (a, b: int) => a+b, () => 0)
    ans = 0
  # 初期値(k = 0のとき)を計算
  for i in N:
    ans += st[A[i] + 1 .. ^1]
    st[A[i]] = st[A[i]] + 1
    # kの処理終了後にやる
    let k = M - A[i] - 1
    a[k].add i
  for k in 0 ..< M:
    echo ans
    if k == M - 1: break
    a[k].sort
    # N - a[k].len個ある
    for i in a[k].len:
      # a[k][i]個のうちi個がMであるのでこの分が逆転する
      let
        pos = a[k][i] - i
        neg = N - a[k].len - pos
      ans += pos
      ans -= neg

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

