const
  DO_CHECK = true
  DEBUG = true
  USE_DEFAULT_TABLE = true

include lib/header/chaemon_header

solveProc solve(N:int, L:int, R:int):
  # L ..< R
  # N - 1個: (0, 1), (0, 2), ..., (0, N - 1) -> 0 ..< N - 1
  # N - 2個: (1, 2), (1, 3), ..., (1, N - 1) -> 
  # ...
  #
  # (N - 1) + (N - 2) + ... + 
  A := (1 .. N).toSeq
  t := 0
  s := 0
  while true:
    # N - 1 - t個ある
    # s ..< s + N - 1 - t
    if L in s ..< s + N - 1 - t:
      if R <= s + N - 1 - t:
        for i in L - s + t + 1 ..< R - s + t + 1:
          swap A[t], A[i]
        echo A.join(" ");return
      else:
        i := L - s + t + 1
        while i < N:
          swap A[t], A[i]
          i.inc
        s += N - 1 - t
        t.inc
        break
    s += N - 1 - t
    t.inc
  var
    Al = A[0 ..< t]
    Ar = initDeque[int]()
  for i in t ..< A.len:
    Ar.addLast(A[i])
  while true:
    if R <= s + N - 1 - t:
      A = Al & Ar.toSeq
      for i in t + 1 ..< R - s + t + 1:
        swap A[t], A[i]
      break
    else:
      # (t, t + 1), (t, t + 2), ..., (t, N - 1)のswapをする
      Al.add(Ar.popLast)
    s += N - 1 - t
    t.inc
  echo A.join(" ")
  Naive:
    # L ..< R
    var A = (1 .. N).toSeq
    var v:seq[(int, int)]
    for x in N:
      for y in x + 1 ..< N:
        v.add (x, y)
    v = v[L ..< R]
    for (x, y) in v:
      swap A[x], A[y]
    echo A.join(" ")
  discard

when not defined(DO_TEST):
  var N = nextInt()
  var L = nextInt() - 1
  var R = nextInt()
  solve(N, L, R)
else:
  for N in 10:
    let M = (N * (N - 1)) div 2
    for L in 0 ..< M:
      for R in L + 1 .. M:
        debug N, L, R
        test(N, L, R)
