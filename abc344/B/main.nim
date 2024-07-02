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
  var A = Seq[int]
  while true:
    let a = nextInt()
    A.add a
    if a == 0: break
  A.reverse
  echo A.join("\n")
  discard

when not DO_TEST:
  solve()
else:
  discard

