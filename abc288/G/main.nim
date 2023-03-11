when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

# Failed to predict input format
solveProc solve(N:int, A:seq[int]):
  var p3 = Seq[N + 1: int]
  p3[0] = 1
  for i in 1 .. N:
    p3[i] = p3[i - 1] * 3
  proc calc(n:int, A:seq[int]):seq[int] =
    if n == 0: return A
    let l = p3[n - 1]
    var p, q, r: seq[int]
    for i in l:
      # A[i], A[i + l], A[i + 2 * l]
      let
        a = A[i + l] - A[i + 2 * l]
        c = A[i + l] - A[i]
        b = A[i + l] - a - c
      p.add a
      q.add b
      r.add c
    return calc(n - 1, p) & calc(n - 1, q) & calc(n - 1, r)
  var B = calc(N, A)
  echo B.join(" ")
  discard

when not defined(DO_TEST):
  let N = nextInt()
  var A = Seq[3^N: nextInt()]
  solve(N, A)
else:
  discard

