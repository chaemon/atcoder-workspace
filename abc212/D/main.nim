const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

import lib/structure/set_map

block main:
  let Q = nextInt()
  var a:SortedSet(int, comp = (a, b:int) => a < b)
  a.init()
  var s = 0
  for _ in Q:
    echo a
    let t = nextInt()
    case t
    of 1:
      let X = nextInt() - s
      a.insert(X)
    of 2:
      let X = nextInt()
      s += X
    of 3:
      var it = a.begin()
      echo *it + s
      a.erase(it)
    else:
      discard
