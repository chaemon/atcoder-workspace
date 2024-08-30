when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, H:int, a:seq[int], operation:seq[string], arg:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var H = nextInt()
  var a = newSeqWith(N, nextInt())
  var operation = newSeqWith(M, "")
  var arg = newSeqWith(M, 0)
  for i in 0..<M:
    operation[i] = nextString()
    arg[i] = nextInt()
  solve(N, M, H, a, operation, arg)
else:
  discard

