include atcoder/extra/header/chaemon_header

proc solve(N:int, A:seq[int], B:seq[int]) =
  var f = int.inf
  var ans = int.inf
  var s = 0
  if A[N - 1] <= B[N - 1]:
    echo B[N - 1] - A[N - 1] + 1
    return
  for i in countdown(N - 1, 0):
    if A[i] <= B[i]:
      ans.min= s + B[i] - A[i] + 1
      if A[i] < f:
        s += f - A[i]
    else:
      f.min= A[i] - B[i]
  ans.min=s
  echo s
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, nextInt())
  var B = newSeqWith(N, nextInt())
  solve(N, A, B)
#}}}
