const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

const YES = "Yes"
const NO = "No"

# Failed to predict input format
solveProc solve(A, B:seq[int]):
  var (A, B) = block:
    var
      A2:array[1..5, int]
      B2:array[1..5, int]
    for i in 1 .. 5: A2[i] = A[i - 1]
    for i in 1 .. 5: B2[i] = B[i - 1]
    (A2, B2)
  block:
    Asum := 0
    Bsum := 0
    for i in 1..5:
      Asum += A[i] * i
      Bsum += B[i] * i
    if Asum > Bsum: echo NO;return
  # 重さ5の荷物を体力5の人に割り当てる
  if A[5] > B[5]: echo NO;return
  B[5] -= A[5]
  # 重さ4の荷物を体力4, 5の人の順に割り当てる
  if A[4] > B[4] + B[5]: echo NO;return
  if B[4] >= A[4]:
    B[4] -= A[4]
  else:
    A[4] -= B[4]
    B[4] = 0
    B[5] -= A[4]
    B[1] += A[4]
  # 重さ3の荷物を体力3, 5, 4の人の順に割り当てる
  if A[3] > B[3] + B[4] + B[5]: echo NO;return
  if B[3] >= A[3]:
    B[3] -= A[3]
  else:
    A[3] -= B[3]
    B[3] = 0
    if B[5] >= A[3]:
      B[5] -= A[3]
      B[2] += A[3]
    else:
      A[3] -= B[5]
      B[2] += B[5]
      B[5] = 0
      B[4] -= A[3]
      B[1] += A[3]
  if A[2] > B[2] + B[3] + B[4] * 2 + B[5] * 2:
    echo NO;return
  echo YES
  Naive:
    var (A, B) = block:
      var
        A2:array[1..5, int]
        B2:array[1..5, int]
      for i in 1 .. 5: A2[i] = A[i - 1]
      for i in 1 .. 5: B2[i] = B[i - 1]
      (A2, B2)
    block:
      Asum := 0
      Bsum := 0
      for i in 1..5:
        Asum += A[i] * i
        Bsum += B[i] * i
      if Asum > Bsum: echo NO;return
    found := false
    proc f(i: int) =
      if found: return
      if i == 1:
        found = true
        return
      # A[i]の荷物1つをB[j]に持たせる
      if A[i] == 0: f(i - 1)
      else:
        for j in i .. 5:
          if B[j] == 0: continue
          A[i].dec
          B[j].dec
          if j - i > 0: B[j - i].inc
          f(i)
          A[i].inc
          B[j].inc
          if j - i > 0: B[j - i].dec
    f(5)
    if found: echo YES
    else: echo NO
  discard

when not defined(DO_TEST):
  let T = nextInt()
  for _ in T:
    let
      A = Seq[5: nextInt()]
      B = Seq[5: nextInt()]
    solve(A, B)
    #test(A, B)
else:
  import random
  const MAX = 5
  for _ in 100:
    var A, B:seq[int]
    for i in 5:
      A.add random.rand(0 .. MAX)
    for i in 5:
      B.add random.rand(0 .. MAX)
    debug A, B
    test(A, B)
