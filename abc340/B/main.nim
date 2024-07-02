when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

# Failed to predict input format
solveProc solve():
  Q := nextInt()
  a := Seq[int]
  for _ in Q:
    t := nextInt()
    if t == 1:
      x := nextInt()
      a.add x
    else:
      k := nextInt()
      echo a[a.len - k]
  discard

when not DO_TEST:
  solve()
else:
  discard

