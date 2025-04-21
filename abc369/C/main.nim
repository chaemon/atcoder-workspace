when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve():
  let
    N = nextInt()
    A = Seq[N: nextInt()]
  var
    ans = N
    d:seq[int]
  for i in N - 1:
    d.add A[i + 1] - A[i]
  i := 0
  while i < d.len:
    var j = i
    while j < d.len and d[i] == d[j]:
      j.inc
    let p = j - i
    ans += (p * (p + 1)) div 2
    i = j
  echo ans
  discard

when not defined(DO_TEST):
  solve()
else:
  discard

