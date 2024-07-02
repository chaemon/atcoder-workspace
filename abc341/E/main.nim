when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree

const YES = "Yes"
const NO = "No"
# Failed to predict input format
solveProc solve():
  let
    N, Q = nextInt()
    S = nextString()
  var st = initSegTree[int](N - 1, (a, b:int)=>a + b, ()=>0)
  # st[i]: S[i]とS[i + 1]が同じなら0異なるなら1
  for i in N - 1:
    if S[i] == S[i + 1]: st[i] = 0
    else: st[i] = 1
  for i in Q:
    let t = nextInt()
    var L, R = nextInt()
    L.dec
    # L ..< R
    if t == 1:
      if L > 0:
        if st[L - 1] == 1:
          st[L - 1] = 0
        else:
          st[L - 1] = 1
      if R < N:
        if st[R - 1] == 1:
          st[R - 1] = 0
        else:
          st[R - 1] = 1
    else:
      if L > R - 2 or st[L ..< R - 1] == R - 1 - L:
        echo YES
      else:
        echo NO
      discard
  discard

when not DO_TEST:
  solve()
else:
  discard

