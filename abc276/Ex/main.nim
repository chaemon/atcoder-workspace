when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
import atcoder/modint
const MOD = 3
#type mint = modint3

solveProc solve(N:int, Q:int, a:seq[int], b:seq[int], c:seq[int], d:seq[int], e:seq[int]):
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var Q = nextInt()
  var a = newSeqWith(Q, 0)
  var b = newSeqWith(Q, 0)
  var c = newSeqWith(Q, 0)
  var d = newSeqWith(Q, 0)
  var e = newSeqWith(Q, 0)
  for i in 0..<Q:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
    d[i] = nextInt()
    e[i] = nextInt()
  solve(N, Q, a, b, c, d, e)
else:
  discard

