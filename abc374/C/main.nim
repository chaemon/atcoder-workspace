when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(N:int, K:seq[int]):
  ans := int.inf
  for b in 2^N:
    s := 0
    t := 0
    for i in N:
      if b[i] == 1:
        s += K[i]
      else:
        t += K[i]
    ans.min=max(s, t)
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var K = newSeqWith(N, nextInt())
  solve(N, K)
else:
  discard

