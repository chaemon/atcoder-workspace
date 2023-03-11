const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, X:int, Y:int, A:seq[int]):
  proc calc(A:seq[int]):int =
    let N = A.len
    var dpX, dpY = Seq[N + 1: -1]
    dpX[N] = N
    proc nextX(i:int):int =
      if dpX[i] == -1:
        if A[i] == X:
          dpX[i] = i
        else:
          dpX[i] = nextX(i + 1)
      return dpX[i]
    dpY[N] = N
    proc nextY(i:int):int =
      if dpY[i] == -1:
        if A[i] == Y:
          dpY[i] = i
        else:
          dpY[i] = nextY(i + 1)
      return dpY[i]
    result = 0
    for i in N:
      result += N - max(nextX(i), nextY(i))
  var ans = 0
  For (i := 0), i < N, i.inc:
    if A[i] notin Y..X:
      continue
    var j = i
    while j < N and A[j] in Y..X: j.inc
    ans += calc(A[i..<j])
    i = j
  echo ans
  Naive:
    ans := 0
    for L in 0..<N:
      for R in L+1..N:
        let A = A[L..<R]
        if A.min == Y and A.max == X: ans.inc
    echo ans

when not DO_TEST:
  var N = nextInt()
  var X = nextInt()
  var Y = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, X, Y, A)
else:
  var ct = 0
  for a in 1..4:
    for b in 1..4:
      for c in 1..4:
        for d in 1..4:
          for e in 1..4:
            for f in 1..4:
              var A = @[a, b, c, d, e, f]
              let N = A.len
              for X in 1..4:
                for Y in 1..X:
                  test(N, X, Y, A)
                  ct.inc
  echo "passed ", ct, " tests"
  discard

