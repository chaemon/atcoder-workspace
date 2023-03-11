const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import deques


# Failed to predict input format
solveProc solve():
  var q = initDeque[tuple[x, c:int]]()
  let Q = nextInt()
  for i in Q:
    let t = nextInt()
    if t == 1:
      let x, c = nextInt()
      q.addLast((x, c))
    else:
      var
        c = nextInt()
        s = 0
      while c > 0:
        var (x0, c0) = q.popFirst()
        if c0 <= c:
          c -= c0
          s += x0 * c0
        else:
          c0 -= c
          s += x0 * c
          c = 0
          q.addFirst((x0, c0))
      echo s
  discard

when not DO_TEST:
  solve()
else:
  discard

