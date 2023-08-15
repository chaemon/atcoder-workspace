when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:int, op:seq[string], B:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = nextInt()
  var op = newSeqWith(N, "")
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    op[i] = nextString()
    B[i] = nextInt()
  solve(N, A, op, B)
else:
  discard

