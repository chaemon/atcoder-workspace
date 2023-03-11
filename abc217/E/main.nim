const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header
import lib/structure/set_map
import deques


# Failed to predict input format


solveProc solve():
  var d = initDeque[int]()
  var s = initSortedMultiSet(int)
  proc query() =
    let e = nextInt()
    if e == 1:
      let x = nextInt()
      d.addLast(x)
    elif e == 2:
      if s.len > 0:
        echo *s.begin()
        s.erase(s.begin())
      else:
        echo d.popFirst()
    else:
      while d.len > 0:
        s.insert(d.popFirst)
  let Q = nextInt()
  for _ in Q:
    query()

block main:
  solve()
  discard

