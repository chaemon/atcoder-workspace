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
  var s = Seq[100: 0]
  for _ in Q:
    let t = nextInt()
    if t == 1:
      let x = nextInt()
      s.add x
    else:
      echo s.pop()

when not DO_TEST:
  solve()
else:
  discard

