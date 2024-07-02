const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import atcoder/extra/structure/set_map

# Failed to predict input format
solveProc solve():
  let Q = nextInt()
  var st = initSortedMap[int, int]()
  for _ in Q:
    let t = nextInt()
    if t == 1:
      let x = nextInt()
      st[x].inc
    elif t == 2:
      let x, c = nextInt()
      st[x] -= c
      if st[x] <= 0:
        st.erase(x)
    else:
      var it = st.end()
      it -= 1
      echo (*it)[0] - (*st.begin())[0]
  discard

when not DO_TEST:
  solve()
else:
  discard

