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
  var a = initTable[int, int]()
  for _ in nextInt():
    let t = nextInt()
    if t == 1:
      let x = nextInt()
      a[x].inc
    elif t == 2:
      let x = nextInt()
      a[x].dec
      if a[x] == 0:
        a.del x
    else:
      echo a.len
  discard

when not DO_TEST:
  solve()
else:
  discard

