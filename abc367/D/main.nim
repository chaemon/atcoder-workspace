when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, M:int, A:seq[int]):
  var
    r = Seq[M: 0]
    s = 0
    ans = 0
  for i in N:
    r[s].inc
    s = (s + A[i]) mod M
  let s0 = s
  for i in N:
    r[(s - s0).floorMod M].dec
    ans += r[s]
    r[s].inc
    s = (s + A[i]) mod M
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
else:
  discard

