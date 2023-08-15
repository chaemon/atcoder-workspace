when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var
    p = 1
    s = 0
  for _ in 16:
    let P = p * 10
    # 繰り上がりなしの和
    for i in N:
      let d = (A[i] div p) mod 10
      s += d * N * 2
    # 繰り上がり回数を数える
    c := 0 # 繰り上がり回数
    var v = @(int)
    for i in N:
      v.add A[i] mod P
    v.sort
    for i in v.len:
      # v[i] + v[j] >= Pとなる個数だけ繰り上がる
      c += N - v.lowerBound(P - v[i])
    s -= c * 9
    p = P
  echo s
  discard

when not defined(DO_TEST):
  let
    N = nextInt()
    A = N @ nextInt()
  solve(N, A)
else:
  discard

