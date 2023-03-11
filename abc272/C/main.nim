when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int]):
  var odd, even: seq[int]
  for a in A:
    if a mod 2 == 0: even.add a
    else: odd.add a
  odd.sort
  even.sort
  ans := -1
  if odd.len >= 2:
    ans.max=odd[^1] + odd[^2]
  if even.len >= 2:
    ans.max=even[^1] + even[^2]
  echo ans
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, A)
else:
  discard

