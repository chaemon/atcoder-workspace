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
solveProc solve(N:int, S:int, A:seq[int]):
  let
    r = S mod A.sum
  debug r
  for i in 1 .. N:
    for j in N:
      if A[i ..< N].sum + A[0 ..< j].sum == r:
        debug i, j

  # A_N, A_1をまたぐ場合suffixとprefixの和がrになればよい
  block:
    var
      suffix = A.sum
      prefix = 0
      i = 0
      j = 0
    # iからのsuffix
    # 0 ..< jのprefix
    for i in 0 .. N:
      while j < N and suffix + prefix < r:
        prefix += A[j]
        j.inc
      if suffix + prefix == r:
        echo YES;return
      if i == N: break
      suffix -= A[i]
  # i ..< jの和
  block:
    var
      j = 0
      s = 0
    for i in 0 ..< N:
      while j < N and s < S:
        s += A[j]
        j.inc
      if s == S: echo YES;return
      s -= A[i]
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var S = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, S, A)
else:
  discard

