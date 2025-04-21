when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(S:string, N:int, c:seq[string], v:seq[int]):
  discard

when not defined(DO_TEST):
  var S = nextString()
  var N = nextInt()
  var c = newSeqWith(N, "")
  var v = newSeqWith(N, 0)
  for i in 0..<N:
    c[i] = nextString()
    v[i] = nextInt()
  solve(S, N, c, v)
else:
  discard

