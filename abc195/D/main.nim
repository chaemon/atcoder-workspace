include atcoder/extra/header/chaemon_header


#const DEBUG = true

# Failed to predict input format
block main:
  let N, M, Q = nextInt()
  var (W, V) = unzip(N, (nextInt(), nextInt()))
  v := newSeq[(int,int)]()
  for i in 0..<N: v.add((V[i], W[i]))
  v.sort()
  v.reverse()
  let X = Seq(M, nextInt())
  for _ in Q:
    var L, R = nextInt() - 1
    var box = newSeq[int]()
    for i in 0..<M:
      if i in L..R: continue
      box.add X[i]
    box.sort()
    debug box
    ans := 0
    for (V, W) in v:
      var box2 = newSeq[int]()
      found := false
      for b in box:
        if not found and b >= W:
          found = true
          ans += V
        else:
          box2.add b
      box.swap box2
    echo ans
  discard

