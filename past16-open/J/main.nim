when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, A:seq[int]):
  var g = 0
  for i in K - 1:
    g = gcd(g, A[i + 1] - A[i])
  var ds:seq[int]
  for d in 1 .. g:
    if d * d > g: break
    if g mod d != 0: continue
    ds.add d
    if d * d < g:
      ds.add g div d
  ds.sort
  var ans:seq[int]
  for d in ds:
    if A[0] + (N - 1) * d < A[^1]: continue
    ans.add d
  echo ans.len
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(K, nextInt())
  solve(N, K, A)
else:
  discard

