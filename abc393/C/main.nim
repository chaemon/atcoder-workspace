when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, u:seq[int], v:seq[int]):
  Pred u, v
  var
    a = initSet[(int, int)]()
    ans = 0
  for i in M:
    var (u, v) = (u[i], v[i])
    if u > v: swap u, v
    if u == v: ans.inc
    elif (u, v) in a: ans.inc
    else: a.incl((u, v))
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var u = newSeqWith(M, 0)
  var v = newSeqWith(M, 0)
  for i in 0..<M:
    u[i] = nextInt()
    v[i] = nextInt()
  solve(N, M, u, v)
else:
  discard

