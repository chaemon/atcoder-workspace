when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:seq[string], A:seq[int]):
  var a = 0
  for i in N:
    case T[i][0]:
      of '+': a += A[i]
      of '-': a -= A[i]
      of '*': a *= A[i]
      else:
        discard
    a = a.floorMod 10000
    echo a
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = newSeqWith(N, "")
  var A = newSeqWith(N, 0)
  for i in 0..<N:
    T[i] = nextString()
    A[i] = nextInt()
  solve(N, T, A)
else:
  discard

