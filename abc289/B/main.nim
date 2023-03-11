when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, M:int, a:seq[int]):
  Pred a
  var s = Seq[N - 1: false]
  for a in a:
    s[a] = true
  i := 0
  ans := Seq[int]
  while i < N:
    j := i
    while j < N - 1 and s[j]:
      j.inc
    # i, i + 1, ..., jを逆順に
    for t in countdown(j, i):
      ans.add t + 1
    i = j + 1
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var M = nextInt()
  var a = newSeqWith(M, nextInt())
  solve(N, M, a)
else:
  discard

