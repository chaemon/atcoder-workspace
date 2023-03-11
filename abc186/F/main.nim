include atcoder/extra/header/chaemon_header



import atcoder/segtree

proc solve(H:int, W:int, M:int, X:seq[int], Y:seq[int]) =
  H2 := H
  W2 := W
  ans := 0
  for i in 0..<M:
    if X[i] == 0: W2.min=Y[i]
    if Y[i] == 0: H2.min=X[i]
#  ans += H * W - H2 * W2
  block:
    var p = newSeqWith(W, newSeq[int]())
    for i in M:
      p[Y[i]].add(X[i])
    for i in W2:
      if p[i].len == 0:
        ans += H - H2
      else:
        p[i].sort()
        let t = p[i][0]
        if t >= H2: ans += t - H2
  block:
    var p = newSeqWith(H, newSeq[int]())
    for i in M:
      p[X[i]].add(Y[i])
    for i in H2:
      if p[i].len == 0:
        ans += W - W2
      else:
        p[i].sort()
        let t = p[i][0]
        if t >= W2: ans += t - W2
  let
    H = H2
    W = W2
  var p = newSeqWith(W, newSeq[int]())
  for i in 0..<M:
    if X[i] >= H or Y[i] >= W: continue
    p[Y[i]].add(X[i])
#  var st = initSegTree(H, (a, b:int)=>a+b, ()=>0)
  var st = SegTree.getType(int, (a, b:int)=>a+b, ()=>0).init(H)
  for i in 0..<H: st[i] = 1
  var s = 0
  for y in 0..<W:
    if p[y].len == 0:
      s += H
    else:
      p[y].sort()
      let t = p[y][0]
      s += t
      for x in p[y]:st[x] = 0
      s += st.prod(t+1..<H)
  ans += s
  echo ans
  return

# input part {{{
block:
  var H = nextInt()
  var W = nextInt()
  var M = nextInt()
  var X = newSeqWith(M, 0)
  var Y = newSeqWith(M, 0)
  for i in 0..<M:
    X[i] = nextInt() - 1
    Y[i] = nextInt() - 1
  solve(H, W, M, X, Y)
#}}}
