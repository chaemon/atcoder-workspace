include atcoder/extra/header/chaemon_header



solveProc solve(N:int, M:int, A:seq[int]):
  var a = Seq[N: @[-1]]
  for i in 0..<N:
    a[A[i]].add i
  for i in 0..<N:
    a[i].add N
  for i in 0..<N:
    for j in 0..<a[i].len - 1:
      if a[i][j + 1] - a[i][j] > M:
        echo i; return
  echo N
  return

# input part {{{
block:
  var N = nextInt()
  var M = nextInt()
  var A = newSeqWith(N, nextInt())
  solve(N, M, A)
#}}}

