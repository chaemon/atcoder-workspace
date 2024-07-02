when defined SecondCompile:
  const DO_CHECK = false;const DEBUG = false
else:
  const DO_CHECK = true;const DEBUG = true
const
  USE_DEFAULT_TABLE = true
  DO_TEST = false


include lib/header/chaemon_header

solveProc solve(N:int, T:int, A:seq[int], B:seq[int]):
  Pred A
  var
    v = Seq[N: 0]
    s = initTable[int, int]()
  s[0] = N
  for i in T:
    s[v[A[i]]].dec
    if s[v[A[i]]] == 0:
      s.del v[A[i]]
    v[A[i]] += B[i]
    s[v[A[i]]].inc
    echo s.len
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var T = nextInt()
  var A = newSeqWith(T, 0)
  var B = newSeqWith(T, 0)
  for i in 0..<T:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, T, A, B)
else:
  discard

