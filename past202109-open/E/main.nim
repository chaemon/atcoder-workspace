when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, K:int, c:seq[int], p:seq[int]):
  var v = initTable[int, int]()
  for i in N:
    if c[i] notin v:
      v[c[i]] = p[i]
    else:
      v[c[i]].min=p[i]
  if v.len < K:
    echo -1;return
  var w = @((int, int))
  for k, v in v:
    w.add (v, k)
  w.sort
  ans := 0
  for i in K:
    ans += w[i][0]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var c = newSeqWith(N, nextInt())
  var p = newSeqWith(N, nextInt())
  solve(N, K, c, p)
else:
  discard

