when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, R:seq[int]):
  var
    v = 1.repeat(N)
    ans:seq[seq[int]]
  while true:
    if v.sum mod K == 0:
      ans.add v
    var i = 0
    while i < N:
      if v[i] < R[i]:
        v[i].inc
        break
      else:
        v[i] = 1
      i.inc
    if i == N: break
  ans.sort
  for v in ans:
    echo v.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var R = newSeqWith(N, nextInt())
  solve(N, K, R)
else:
  discard

