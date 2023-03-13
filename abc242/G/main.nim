const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/structure/mo

# Failed to predict input format
solveProc solve():
  var
    N = nextInt()
    A = Seq[N: nextInt() - 1]
    Q = nextInt()
    l, r = Seq[Q: int]
    ans = Seq[Q: int]
  for i in Q:
    l[i] = nextInt() - 1
    r[i] = nextInt()
  var
    mo = initMo(N, l, r)
    ct = Seq[N: 0]
    num_odd = 0
    s = 0
  proc addLeft(i:int) =
    let i = A[i]
    s -= ct[i]
    if ct[i] mod 2 == 1: num_odd.dec
    ct[i].inc
    if ct[i] mod 2 == 1: num_odd.inc
    s += ct[i]
  proc addRight(i:int) =
    addLeft(i)
  proc deleteLeft(i:int) =
    let i = A[i]
    s -= ct[i]
    if ct[i] mod 2 == 1: num_odd.dec
    ct[i].dec
    if ct[i] mod 2 == 1: num_odd.inc
    s += ct[i]
  proc deleteRight(i:int) =
    deleteLeft(i)
  proc rem(i:int) =
    doAssert (s - num_odd) mod 2 == 0
    #debug ct, s, num_odd
    ans[i] = (s - num_odd) div 2 
  mo.run(addLeft, addRight, deleteLeft, deleteRight, rem)
  echo ans.join("\n")
  discard

when not DO_TEST:
  solve()
else:
  discard

