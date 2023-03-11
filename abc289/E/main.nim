when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, C:seq[int], u:seq[int], v:seq[int]):
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var M = nextInt()
    var C = newSeqWith(N, nextInt())
    var u = newSeqWith(M, 0)
    var v = newSeqWith(M, 0)
    for i in 0..<M:
      u[i] = nextInt()
      v[i] = nextInt()
    solve(N, M, C, u, v)
else:
  discard

