when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, H:seq[int]):
  var
    M = M
    ans = 0
  for i in N:
    if M >= H[i]:
      ans.inc
      M -= H[i]
    else:
      break
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var H = newSeqWith(N, nextInt())
  solve(N, M, H)
else:
  discard

