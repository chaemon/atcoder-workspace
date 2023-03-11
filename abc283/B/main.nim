when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  let N = nextInt()
  var A = Seq[N:nextInt()]
  let Q = nextInt()
  for _ in Q:
    let t = nextInt()
    if t == 1:
      var k, x = nextInt()
      k.dec
      A[k] = x
    else:
      echo A[nextInt() - 1]
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

