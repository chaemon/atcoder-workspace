when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int, A: seq[int], M: int, B: seq[int]):
  var x = 0
  for a in A:
    x += a
    if x in B: x = 0
  echo x
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var M = nextInt()
  var B = newSeqWith(M, nextInt())
  solve(N, A, M, B)
else:
  discard

