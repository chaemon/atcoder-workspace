when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, H:seq[int]):
  for i in 1 ..< N:
    if H[0] < H[i]:
      echo i + 1;return
  echo -1
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var H = newSeqWith(N, nextInt())
  solve(N, H)
else:
  discard

