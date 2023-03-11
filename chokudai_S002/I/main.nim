include atcoder/extra/header/chaemon_header

const DEBUG = true

proc solve(N:int, A:seq[int], B:seq[int]) =
  var v = collect(newSeq):
    for i in 0..<N: (A[i] * B[i], i)
  v.sort(Descending)
  if v[0][0] == v[1][0]:
    echo -1;return
  let t = v[0][1]
  for i in 0..<N:
    if i == t: continue
    var k = A[t] div B[i]
    if A[t] mod B[i] == 0: k.dec
    if A[i] - k * B[t] > 0: echo -1;return
  echo t + 1
  return

# input part {{{
block:
  var N = nextInt()
  var A = newSeqWith(N, 0)
  var B = newSeqWith(N, 0)
  for i in 0..<N:
    A[i] = nextInt()
    B[i] = nextInt()
  solve(N, A, B)
#}}}

