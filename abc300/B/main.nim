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
solveProc solve(H:int, W:int, A:seq[string], B:seq[string]):
  var A = A
  proc shiftH(A:var seq[string]) =
    var A2 = A
    for i in H:
      let i2 = (i + 1) mod H
      for j in W:
        A2[i2][j] = A[i][j]
    A = A2
  proc shiftW(A:var seq[string]) =
    var A2 = A
    for j in W:
      let j2 = (j + 1) mod W
      for i in H:
        A2[i][j2] = A[i][j]
    A = A2
  for i in H:
    for j in W:
      if A == B: echo YES;return
      shiftW(A)
    shiftH(A)
  echo NO

when not defined(DO_TEST):
  var H = nextInt()
  var W = nextInt()
  var A = newSeqWith(H, nextString())
  var B = newSeqWith(H, nextString())
  solve(H, W, A, B)
else:
  discard

