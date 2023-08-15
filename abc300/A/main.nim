when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:int, B:int, C:seq[int]):
  let S = A + B
  for i in N:
    if C[i] == S:
      echo i + 1;break
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var B = nextInt()
  var C = newSeqWith(N, nextInt())
  solve(N, A, B, C)
else:
  discard

