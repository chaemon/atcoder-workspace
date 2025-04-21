when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, P:seq[int]):
  var
    v: seq[tuple[P, i: int]]
    i = 0
    ans = Seq[N: int]
    r = 1
  for i in N:
    v.add (P[i], i)
  v.sort(Descending)
  while i < N:
    var j = i
    while j < N and v[i].P == v[j].P:
      ans[v[j].i] = r
      j.inc
    r += j - i
    i = j
  echo ans.join("\n")
  doAssert false

when not defined(DO_TEST):
  var N = nextInt()
  var P = newSeqWith(N, nextInt())
  solve(N, P)
else:
  discard

