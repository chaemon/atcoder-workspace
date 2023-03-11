const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/structure/universal_segtree
import lib/string/rolling_hash

solveProc solve(S:string, T:string):
  var
    st = initDualSegTree[int](T.len + 1, (a, b:int)=>min(a, b), ()=>int.inf)
    rS = initRollingHash(S)
    rT = initRollingHash(T)
  st[0] = 0
  for i in T.len:
    if st[i] == int.inf:
      continue
    let m = LCP(rS, rT, 0 .. ^1, i .. ^1)
    st.apply(i + 1 .. i + m, st[i] + 1)
  let u = st[T.len]
  if u == int.inf:
    echo -1
  else:
    echo u
  discard

when not DO_TEST:
  var S = nextString()
  var T = nextString()
  solve(S, T)
else:
  discard

