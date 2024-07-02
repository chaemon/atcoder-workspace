when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, A:seq[int], C:seq[int]):
  var
    v: seq[tuple[C, A, i:int]]
    ans:seq[int]
  for i in N:
    v.add (C[i], A[i], i)
  v.sort
  var
    i = 0
    Amax = -int.inf
  while i < N:
    var j = i
    while j < N and v[j].C == v[i].C: j.inc
    for k in i ..< j:
      if v[k].A < Amax:
        discard
      else:
        ans.add v[k].i + 1
    for k in i ..< j:
      Amax.max=v[k].A
    i = j
  ans.sort
  echo ans.len
  echo ans.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var C = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    C[i] = nextInt()
  solve(N, A, C)
else:
  discard

