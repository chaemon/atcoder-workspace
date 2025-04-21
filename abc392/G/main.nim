when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import atcoder/convolution

solveProc solve(N:int, S:seq[int]):
  var
    a, c = Seq[10^6 + 1: int]
    ans = 0
  for i in N:
    a[S[i]].inc
    c[S[i]].inc
  let b = convolution_ll(a, c)
  for i in N:
    ans += b[S[i] * 2]
  echo (ans - N) div 2
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = newSeqWith(N, nextInt())
  solve(N, S)
else:
  discard

