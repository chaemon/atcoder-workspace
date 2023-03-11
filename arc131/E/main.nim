const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true


static:
  const t = instantiationInfo(-1, true)
  echo t

include lib/header/chaemon_header

const NO = "No"

solveProc solve(N:int):
  if N mod 3 == 2 or N <= 4:
    echo NO;return
  proc build(n:int):seq[int] =
    var n = n
    if n >= 12:
      return build(n - 6) & @[0, 1, 2, 2, 1, 0]
    if n == 6:
      return @[0, 1, 2, 2, 1, 0]
    elif n == 7:
      return @[0, 0, 1, 2, 2, 1, 0]
    elif n == 9:
      return @[2, 2, 2, 2, 0, 1, 2, 1, 0]
    elif n == 10:
      return @[2, 2, 2, 2, 2, 2, 0, 1, 1, 0]
    else:
      doAssert false
  echo "Yes"
  var a = build(N)
  block:
    var s = Seq[3: 0]
    for i in N: s[a[i]] += i
    doAssert s[0] == s[1] and s[1] == s[2]
  for i in N - 1:
    var c = ""
    for j in i + 1 ..< N:
      if a[j] == 0: c.add 'R'
      elif a[j] == 1: c.add 'B'
      elif a[j] == 2: c.add 'W'
    echo c
  discard

when not defined(DO_TEST):
  var N = nextInt()
  solve(N)
else:
  for N in 3..50:
    debug N
    solve(N)
