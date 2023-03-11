const
  DO_CHECK = false
  DEBUG = true
  DO_TEST = false
include atcoder/extra/header/chaemon_header

#####################################################
proc `+`[T](a:(T, T), b:(T, T)):(T, T) = (a[0]+b[0], a[1]+b[1])
proc `-`[T](a:(T, T), b:(T, T)):(T, T) = (a[0]-b[0], a[1]-b[1])
proc `+=`[T](a:var (T, T), b:(T, T)) =
  a[0] += b[0]
  a[1] += b[1]
proc `-=`[T](a:var (T, T), b:(T, T))=
  a[0] -= b[0]
  a[1] -= b[1]

proc solve()=
  let
    H = nextInt()
    W = nextInt()
    st, go: tuple[x, y:int] = (nextInt(), nextInt())
    S = '#'.repeat(W+2) & (0..<H).mapIt('#' & nextString() & '#') & '#'.repeat(W+2)
 
  const dir = [(1, 0), (0, 1), (-1, 0), (0, -1)]

  var
    step = Seq[4, H+2, W+2: int.inf]
    vis = Seq[4, H+2, W+2: false]
 
  var q = initDeque[tuple[d, x, y:int]]()
  for d in 0 ..< 4:
    q.addLast((d, st.x, st.y))
    step[d][st.x][st.y] = 0
  while q.len > 0:
    let (d, x, y) = q.popFirst()
    if (x, y) == go:
      echo step[d][x][y]
      break
    if vis[d][x][y]: continue
    vis[d][x][y] = true
    for d2 in 0..<4:
      var ns = step[d][x][y]
      if d2 != d: ns += 1
      let (x2, y2) = (x, y) + dir[d2]
      if S[x2][y2] == '#': continue
      if step[d2][x2][y2] > ns:
        step[d2][x2][y2] = ns
        if d2 == d:
          q.addFirst((d2, x2, y2))
        else:
          q.addLast((d2, x2, y2))

solve()
