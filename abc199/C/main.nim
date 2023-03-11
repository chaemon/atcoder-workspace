include atcoder/extra/header/chaemon_header


const DEBUG = true

# Failed to predict input format
block main:
  let N = nextInt()
  var S = nextString()
  let Q = nextInt()
  flip := false
  for _ in Q:
    var T, A, B = nextInt()
    A.dec;B.dec
    if T == 1:
      if flip:
        if A >= N: A = A - N
        else: A = A + N
        if B >= N: B = B - N
        else: B = B + N
      swap(S[A], S[B])
    else:
      flip = flip xor true
  if flip:
    var S2 = S
    S2[0..<N] = S[N..<N*2]
    S2[N..<N*2] = S[0..<N]
    swap(S, S2)
  echo S
  discard

