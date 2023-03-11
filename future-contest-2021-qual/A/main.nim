include atcoder/extra/header/chaemon_header

proc moveTo(ans:var string, f:(int,int), t:(int, int)) =
  let (fx, fy) = f
  let (tx, ty) = t
  let dx = abs(fx - tx)
  if fx < tx:
    ans &= "D".repeat(dx)
  else:
    ans &= "U".repeat(dx)
  let dy = abs(fy - ty)
  if fy < ty:
    ans &= "R".repeat(dy)
  else:
    ans &= "L".repeat(dy)

proc solve(x:seq[int], y:seq[int]) =
  let B = 20
  let B2 = B div 2
  let N = 100
  var ans = ""
  var a = Seq(B, B, -1)
  for i in 0..<N:a[x[i]][y[i]] = i
  var x0, y0 = 0
  var st = newSeq[int]()
  while true:
    if x0 >= B:break
    if a[x0][y0] >= 0:
      st.add a[x0][y0]
      a[x0][y0] = -1
      ans &= "I"
    if st.len == N:break
    if x0 mod 2 == 0:
      y0.inc
      if y0 >= B:
        y0 = B - 1
        x0.inc
        ans &= "D"
      else:
        ans &= "R"
    else:
      y0.dec
      if y0 < 0:
        y0 = 0
        x0.inc
        ans &= "D"
      else:
        ans &= "L"
  assert st.len == N
  let
    baseX = B2
    baseY = 0
  while st.len > 0:
    let u = st.pop()
    let x = u div B2 + baseX
    var y = u mod B2 + baseY
    if x mod 2 == 1: y = B2 - 1 - y
    moveTo(ans, (x0, y0), (x, y))
    ans &= "O"
    a[x][y] = u
    (x0, y0) = (x, y)
  moveTo(ans, (x0, y0), (baseX, baseY))
  x0 = baseX
  y0 = baseY
  while true:
    if x0 >= B:break
    if a[x0][y0] >= 0:
      st.add a[x0][y0]
      a[x0][y0] = -1
      ans &= "I"
    if st.len == N:break
    if x0 mod 2 == 0:
      y0.inc
      if y0 >= B2:
        y0 = B2 - 1
        x0.inc
        ans &= "D"
      else:
        ans &= "R"
    else:
      y0.dec
      if y0 < 0:
        y0 = 0
        x0.inc
        ans &= "D"
      else:
        ans &= "L"
  echo ans
  return

# input part {{{
block:
  var x = newSeqWith(99-0+1, 0)
  var y = newSeqWith(99-0+1, 0)
  for i in 0..<99-0+1:
    x[i] = nextInt()
    y[i] = nextInt()
  solve(x, y)
#}}}
