when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"
solveProc solve(A:seq[seq[int]]):
  var v, w = Seq[9: seq[int]]
  for i in 9:
    for j in 9:
      v[i].add A[i][j]
      w[j].add A[i][j]
  for i in 9:
    if v[i].toSet.len != 9: echo NO;return
    if w[i].toSet.len != 9: echo NO;return
  for i in 3:
    for j in 3:
      var v:seq[int]
      for k in 3:
        for l in 3:
          v.add A[i * 3 + k][j * 3 + l]
      if v.toSet.len != 9: echo NO;return
  echo YES
  discard

when not defined(DO_TEST):
  var A = newSeqWith(9, newSeqWith(9, nextInt()))
  solve(A)
else:
  discard

