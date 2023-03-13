when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/structure/mo

proc cmb3(n:int):int =
  (n * (n - 1) * (n - 2)) div 6

solveProc solve(N:int, Q:int, A:seq[int], l:seq[int], r:seq[int]):
  var
    mo = initMo(N, l, r)
    ct = Seq[2 * 10^5 + 1: 0]
    s = 0
    ans = Seq[Q:int]
  proc addLeft(l:int) =
    s -= cmb3(ct[A[l]])
    # A[l]を追加
    ct[A[l]].inc
    s += cmb3(ct[A[l]])
  proc addRight(r:int) =
    s -= cmb3(ct[A[r]])
    # A[r]を追加
    ct[A[r]].inc
    s += cmb3(ct[A[r]])
  proc deleteLeft(l:int) =
    s -= cmb3(ct[A[l]])
    # A[l]を削除
    ct[A[l]].dec
    s += cmb3(ct[A[l]])
  proc deleteRight(r:int) =
    s -= cmb3(ct[A[r]])
    # A[r]を削除
    ct[A[r]].dec
    s += cmb3(ct[A[r]])
  proc rem(i:int) =
    ans[i] = s
  mo.run(addLeft, addRight, deleteLeft, deleteRight, rem)
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var
    N, Q = nextInt()
    A = Seq[N: nextInt()]
    l, r = Seq[Q: int]
  for i in Q:
    l[i] = nextInt() - 1
    r[i] = nextInt()
  solve(N, Q, A, l, r)
else:
  discard

