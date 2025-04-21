when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, K:int, A:seq[int]):
  var
    ans = -int.inf
    a = newSeqOfCap[int](K)
  proc calc(a:var seq[int], s:int) =
    if a.len == K:
      ans.max=s
    var l = if a.len == 0: 0 else: a[^1] + 1
    for i in l ..< N:
      a.add i
      calc(a, s xor A[a[^1]])
      discard a.pop
  calc(a, 0)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, K, A)
else:
  discard

