include atcoder/extra/header/chaemon_header


proc solve(r:seq[int], c:seq[int]) =
  let (x0, y0) = (r[0], c[0])
  let (x1, y1) = (r[1], c[1])
  let
    d0 = x0 - y0
    d1 = x1 - y1
    s0 = x0 + y0
    s1 = x1 + y1
  if x0 == x1 and y0 == y1:
    echo 0
    return
  elif d0 == d1 or s0 == s1 or abs(x0 - x1) + abs(y0 - y1) <= 3:
    echo 1
    return
  elif (d0 + d1) mod 2 == 0 or abs(d0 - d1) <= 3 or abs(s0 - s1) <= 3:
    echo 2
  else:
    echo 3
  return

# input part {{{
block:
  var r = newSeqWith(2, 0)
  var c = newSeqWith(2, 0)
  for i in 0..<2:
    r[i] = nextInt()
    c[i] = nextInt()
  solve(r, c)
#}}}
