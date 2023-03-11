when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header
import lib/other/bitutils

solveProc solve(X:int):
  v := Seq[int]
  for i in 0 ..< 60:
    if X[i] == 1:
      v.add i
  ans := Seq[int]
  for b in 2^v.len:
    var X = X
    for j in v.len:
      if b[j] == 1:
        X.xor=1 shl v[j]
    ans.add X
  ans.reverse
  echo ans.join("\n")
  discard

when not defined(DO_TEST):
  var X = nextInt()
  solve(X)
else:
  discard

