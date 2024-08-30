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
solveProc solve(N:int, K:int, A:seq[int], B:seq[int]):
  if A == B:
    echo YES;return
  elif B.toSet.len == N: # 全部異なる場合はA = B以外できない
    echo NO;return
  elif K == 1:
    # 伸縮させることでできるか
    proc f(a:seq[int]):seq[int] =
      i := 0
      while i < N:
        j := i + 1
        while j < N and a[i] == a[j]:
          j.inc
        result.add a[i]
        i = j
    var
      A = f(A)
      B = f(B)
      i = 0
      j = 0
    while j < B.len:
      while i < A.len:
        if A[i] == B[j]: break
        i.inc
      if i == A.len: echo NO;return
      j.inc
    echo YES
  else:
    var
      prev = initTable[int, int]()
      Aset = A.toSet
      dmin = int.inf
    for i in N:
      if B[i] notin Aset:
        echo NO;return
    for i in N:
      if B[i] in prev:
        dmin.min= i - prev[B[i]]
      prev[B[i]] = i
    if dmin > K:
      echo NO;return
    echo YES
  discard

when not defined(DO_TEST):
  var T = nextInt()
  for case_index in 0..<T:
    var N = nextInt()
    var K = nextInt()
    var A = newSeqWith(N, nextInt())
    var B = newSeqWith(N, nextInt())
    solve(N, K, A, B)
else:
  discard

