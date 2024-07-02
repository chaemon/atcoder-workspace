when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/segtree
import lib/string/rolling_hash

const YES = "Yes"
const NO = "No"

type T = tuple[h, rev_h:RH]

proc op(a, b:T):T =
  result.h = a.h & b.h
  result.rev_h = b.rev_h & a.rev_h

proc e():T = (RH(0), RH(0))
  
solveProc solve():
  let N, Q = nextInt()
  var
    S = nextString()
    st = initSegTree[T](N, op, e)
  for i in N:
    let h = RH(S[i])
    st[i] = (h, h)
  for _ in Q:
    let t = nextInt()
    if t == 1:
      let
        x = nextInt() - 1
        c = nextString()[0]
        h = RH(c)
      st[x] = (h, h)
    else:
      let
        L = nextInt() - 1
        R = nextInt()
      let
        n = R - L
        m = n div 2
      if st[L ..< L + m].h == st[R - m ..< R].rev_h:
        echo YES
      else:
        echo NO

when not DO_TEST:
  solve()
else:
  discard

