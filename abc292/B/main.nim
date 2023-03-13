when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

solveProc solve():
  let N, Q = nextInt()
  var yellow = Seq[N + 1: 0]
  for _ in Q:
    let c, x = nextInt()
    y =& yellow[x]
    if c == 1:
      if y >= 0:
        y.inc
        if y == 2:
          y = -1
    elif c == 2:
      y = -1
    else:
      if y == -1:
        echo YES
      else:
        echo NO
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

