const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false

include lib/header/chaemon_header

const EPS = 1e-10

solveProc solve(N:int, A:seq[int], B:seq[int]):
  var left, right = newSeq[float](N + 1)
  block:
    var s = 0.0
    left[0] = 0.0
    for i in 0..<N:
      s += A[i] / B[i]
      left[i + 1] = s
  block:
    var s = 0.0
    right[N] = 0.0
    for i in countdown(N - 1, 0):
      s += A[i] / B[i]
      right[i] = s
  var s = 0.0
  for i in 0..<N:
    if max(left[i], right[i + 1]) - EPS <= min(left[i + 1], right[i]):
      var d = A[i].float
      var l:float
      if left[i] < right[i + 1]:
        let t = right[i + 1] - left[i]
        l = t * B[i]
        s += l
      else:
        let t = left[i] - right[i + 1]
        l = t * B[i]
      d -= l
      let t = d / (B[i] + B[i])
      s += t * B[i]
      echo s
      break
    s += A[i]
  return

when not DO_TEST:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
else:
  discard

