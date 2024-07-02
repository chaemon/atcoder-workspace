when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int):
  if N * N < M:
    echo -1;return
  ans := int.inf
  # X = a * b (a <= b <= Nとする)
  # このときa <= 10^6となるものがとれる
  for a in 1 .. 2 * 10^6:
    if a > N: break
    var b = max(M.ceilDiv(a), a)
    if a > b or b > N: continue
    ans.min= a * b
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  solve(N, M)
else:
  discard

