const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(A:int, B:int):
  var a, b = Seq[int]
  var (A, B) = (A, B)
  while A > 0:
    a.add A mod 10
    A.div= 10
  while B > 0:
    b.add B mod 10
    B.div= 10
  for i in min(a.len, b.len):
    if a[i] + b[i] >= 10: echo "Hard";return
  echo "Easy"
  return

when not DO_TEST:
  var A = nextInt()
  var B = nextInt()
  solve(A, B)
else:
  discard

