when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import lib/other/bitutils

const YES = "Yes"
const NO = "No"
# Failed to predict input format
solveProc solve():
  let N, M = nextInt()
  var
    a, b = Seq[M: seq[int]]
  for i in M:
    let k = nextInt()
    for j in k:
      a[i].add nextInt() - 1
      b[i].add nextInt()
  for x in 2^N:
    ok := true
    for i in M:
      found := false
      for j in a[i].len:
        if x[a[i][j]] == b[i][j]:
          found = true;break
      if not found: ok = false
    if ok: echo YES;return
  echo NO
  doAssert false
  discard

when not DO_TEST:
  solve()
else:
  discard

