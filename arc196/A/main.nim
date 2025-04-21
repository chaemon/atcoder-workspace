when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header
import std/heapqueue

solveProc solve(N:int, A:seq[int]):
  proc calc(A:seq[int]):seq[int] = # result[i]は2 * i個の大きいi個-小さいi個
    result = @[0]
    var
      q_small, q_large = initHeapQueue[int]() # q_smallは大きい順, q_largeは小さい順
      s_small, s_large = 0
    for i in (N div 2):
      for j in [i * 2, i * 2 + 1]:
        q_small.push(-A[j])
        s_small += A[j]
      if q_large.len > 0:
        let a = q_large.pop()
        s_large -= a
        q_small.push(-a)
        s_small += a
      while q_small.len > i + 1:
        let a = - q_small.pop()
        s_small -= a
        q_large.push(a)
        s_large += a
      result.add s_large - s_small
  let m = N div 2
  if N mod 2 == 0:
    var a = A.sorted
    echo a[m ..< N].sum - a[0 ..< m].sum
  else:
    var
      l = calc(A)
      r = calc(A.reversed)
      ans = -int.inf
    for i in countup(0, N - 1, 2):
      # 0 ..< iとi + 1 ..< N
      ans.max=l[i div 2] + r[(N - i - 1) div 2]
    echo ans

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

