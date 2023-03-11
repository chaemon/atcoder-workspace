when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils 

# Failed to predict input format
solveProc solve():
  let N, M = nextInt()
  var S = Seq[int]
  for _ in M:
    b := 0
    let C = nextInt()
    for _ in C:
      var a = nextInt() - 1
      b[a] = 1
    S.add b
  ans := 0
  for b in 1 ..< 2^M:
    var s = 0
    for i in M:
      if b[i] == 1:
        s.or=S[i]
    if s == 2^N - 1:
      ans.inc
  echo ans
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

