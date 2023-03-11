const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const D = 31600

# Failed to predict input format
solveProc solve(N, A, B, X, Y, Z:int):
  proc test_without_3(N:int):int =
    return (N div A) * Y + (N mod A) * X
  proc test_without_2(N:int):int =
    return (N div B) * Z + (N mod B) * X
  if X * A <= Y and X * B <= Z:
    echo N * X
  elif X * A <= Y:
    echo test_without_2(N)
  elif X * B <= Z:
    echo test_without_3(N)
  elif A >= D:
    var ans = int.inf
    For (var i = 0), i * A <= N, i.inc:
      var N = N - i * A
      ans.min= test_without_2(N) + i * Y
    echo ans
  elif B >= D:
    var ans = int.inf
    For (var i = 0), i * B <= N, i.inc:
      var N = N - i * B
      ans.min= test_without_3(N) + i * Z
    echo ans
  elif B * Y <= A * Z: # Type 3はA個未満
    var ans = int.inf
    For (var i = 0), i < A and i * B <= N, i.inc:
      ans.min= i * Z + test_without_3(N - i * B)
    echo ans
  else: # Type 2はB個未満
    var ans = int.inf
    For (var i = 0), i < B and i * A <= N, i.inc:
      ans.min= i * Y + test_without_2(N - i * A)
    echo ans
  discard

when not DO_TEST:
  let T = nextInt()
  for _ in T:
    let N, A, B, X, Y, Z = nextInt()
    solve(N, A, B, X, Y, Z)
else:
  discard
