include atcoder/extra/header/chaemon_header

var N:int
var A:seq[int]

block main:
  N = nextInt()
  A = newSeqWith(N, nextInt())

  var prev = 0
  S := Seq(N, int)
  S[N - 1] = 0
  for i in 0..<N - 1 << 1:
    b := A[i + 1]
    t := 0
    while A[i] > b: b *= 4; t.inc
    debug i, t, prev
    if prev < t:
      S[i] = S[i + 1] + t * (N - 1 - i)
    else:
      S[i] = 
    prev = t
  echo S
