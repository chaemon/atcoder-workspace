when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve():
  let N = nextInt()
  var
    zero = 1
    one = N
  while zero + 1 < one:
    let m = (zero + one) div 2
    echo "? " & $m
    stdout.flushFile()
    let S = nextInt()
    if S == 0:
      zero = m
    else:
      one = m
  echo "! " & $zero
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

