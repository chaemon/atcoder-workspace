const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

import lib/other/bitutils

const YES = "Yes"
const NO = "No"

solveProc solve(a, s:int):
  var s = s
  for i in 60:
    if a[i] == 1:
      s -= 2^(i + 1)
  if s < 0:
    echo NO;return
  for i in 60:
    if a[i] == 1:
      if s[i] == 1:
        echo NO;return
  echo YES
  discard

when not DO_TEST:
  for _ in nextInt():
    var a, s = nextInt()
    solve(a, s)
else:
  discard

