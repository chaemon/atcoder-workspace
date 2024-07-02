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
solveProc solve(N:int, A:seq[int], B:seq[int]):
  Pred A, B
  var
    v = Seq[tuple[x, i:int]]
    p = Seq[N: false]
  for i in N:
    v.add (A[i], i)
    v.add (B[i], i)
  v.sort
  var q:seq[tuple[x, i:int]]
  for (x, i) in v:
    if not p[i]:
      q.add (x, i)
      p[i] = true
    else:
      let (y, j) = q.pop
      if i != j:
        echo YES;return
  echo NO
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

