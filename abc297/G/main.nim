when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, L:int, R:int, A:seq[int]):
  ans := 0
  for A in A:
    ans.xor=(A mod (L + R)) div L
  if ans == 0:
    echo "Second"
  else:
    echo "First"
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt()
  var R = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, L, R, A)
else:
  discard

