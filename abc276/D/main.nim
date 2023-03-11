when defined SecondCompile:
  const DO_CHECK = false; const DEBUG = false
else:
  const DO_CHECK = true; const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header


solveProc solve(N: int, a: seq[int]):
  var t = a[0]
  while t mod 2 == 0: t.div = 2
  while t mod 3 == 0: t.div = 3
  proc calc(p: int): int =
    for i in N:
      if a[i] mod p != 0: return int.inf
      var a = a[i] div p
      while a mod 2 == 0: a.div = 2; result.inc
      while a mod 3 == 0: a.div = 3; result.inc
      if a != 1: return int.inf
  ans := int.inf
  while true:
    var p = t
    while true:
      ans.min = calc(p)
      p *= 3
      if a[0] mod p != 0: break
    t *= 2
    if a[0] mod t != 0: break
  echo if ans == int.inf: -1 else: ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var a = newSeqWith(N, nextInt())
  solve(N, a)
else:
  discard

