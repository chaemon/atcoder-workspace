const
  DO_CHECK = true
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header



# Failed to predict input format
block main:
  let N = nextInt()
  let (t, l, r) = unzip(N, (nextInt(), nextInt(), nextInt()))
  var L, R = Seq[N: float]
  for i in N:
    L[i] = l[i]
    R[i] = r[i]
    if t[i] == 1:
      L[i] -= 0.3
      R[i] += 0.3
    elif t[i] == 2:
      L[i] -= 0.3
      R[i] -= 0.3
    elif t[i] == 3:
      L[i] += 0.3
      R[i] += 0.3
    elif t[i] == 4:
      L[i] += 0.3
      R[i] -= 0.3
    else:
      assert false
  var ans = 0
  for i in N:
    for j in i+1..<N:
      if max(L[i], L[j]) < min(R[i], R[j]): ans.inc
  echo ans
  discard

