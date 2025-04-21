when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let Q = nextInt()
  var
    d = initDeque[int]()
    s = 0
  for _ in Q:
    let t = nextInt()
    case t
    of 1:
      let l = nextInt()
      d.addLast s
      s += l
    of 2:
      d.popFirst
    of 3:
      let k = nextInt() - 1
      echo d[k] - d[0]
    else:
      doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

