when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, Q:int, S:string, a:seq[int], b:seq[int], c:seq[int], d:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var S = nextString()
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  var c = newSeqWith(Q, 0)
  var d = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
    d[i] = nextInt()
  solve(N, Q, S, a, b, c, d)
else:
  discard

