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
solveProc solve(a:seq[int], b:seq[int], c:seq[int], d:seq[int]):
  discard

when not defined(DO_TEST):
  var a = newSeqWith(2, 0)
  var b = newSeqWith(2, 0)
  var c = newSeqWith(2, 0)
  var d = newSeqWith(2, 0)
  for i in 0..<2:
    a[i] = nextInt()
    b[i] = nextInt()
    c[i] = nextInt()
    d[i] = nextInt()
  solve(a, b, c, d)
else:
  discard

