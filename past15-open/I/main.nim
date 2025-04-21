when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const M = 10^6

solveProc solve(N:int, K:int, A:seq[int]):
  var
    a, ct = Seq[M + 1: 0]
    ans = 0
  for i in N:
    a[A[i]] += 1
  for d in 1 .. M:
    for k in countup(d, M, d):
      ct[d] += a[k]
  for d in 1 .. M:
    if ct[d] >= K:
      ans.max=d
  echo ans
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

