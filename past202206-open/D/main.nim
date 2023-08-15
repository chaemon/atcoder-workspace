when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/dsu

const YES = "Yes"
const NO = "No"
solveProc solve(N:int, a:seq[string], b:seq[string], S:string, T:string):
  var d = initDSU(26)
  for i in N:
    let (a, b) = (a[i][0], b[i][0])
    d.merge(a - 'a', b - 'a')
  for i in S.len:
    if not d.same(S[i] - 'a', T[i] - 'a'): echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, "")
  var b = newSeqWith(N, "")
  for i in 0..<N:
    a[i] = nextString()
    b[i] = nextString()
  var S = nextString()
  var T = nextString()
  solve(N, a, b, S, T)
else:
  discard

