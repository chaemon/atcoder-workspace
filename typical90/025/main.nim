const
  DO_CHECK = true
  DEBUG = true
include atcoder/extra/header/chaemon_header

var p = [2, 3, 5, 7]

solveProc solve(N:int, B:int):
  proc test(m:int):bool =
    var
      M = m
      P0 = 1
    while M > 0:
      P0 *= M mod 10
      M.div= 10
    return m - P0 == B

  ans := 0
  proc f(i, P:int) =
    if i == 4:
      if test(P + B):
        ans.inc
      return
    P := P
    while P + B <= N:
      f(i + 1, P)
      P *= p[i]
  if B in 1 .. N and test(B): ans.inc
  f(0, 1)
  echo ans
  Naive:
    ans := 0
    for m in 1 .. N:
      p := 1
      block:
        var m = m
        while m > 0:
          p *= m mod 10
          m.div=10
      if m - p == B:
        ans.inc
    echo ans
  return

when not defined(DO_TEST):
  var N = nextInt()
  var B = nextInt()
  solve(N, B)
else:
  for (N, B) in (1 .. 1000)^2:
    debug "test: ", N, B
    test(N, B)
