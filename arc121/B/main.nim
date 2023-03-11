include atcoder/extra/header/chaemon_header


const DEBUG = true

proc dist(v, w:seq[int]):int =
  var (v, w) = (v, w)
  v.sort()
  w.sort()
  var ans = int.inf
  for i in v.len:
    let j = w.lower_bound(v[i])
    if j in 0..<w.len:
      ans.min=(abs(v[i] - w[j]))
    if j - 1 in 0..<w.len:
      ans.min=(abs(v[i] - w[j - 1]))
  return ans


proc solve(N:int, a:seq[int], c:seq[string]) =
  var R, G, B = 0
  for i in N * 2:
    let c = c[i][0]
    if c == 'R': R.inc
    elif c == 'G': G.inc
    elif c == 'B': B.inc
  if R mod 2 == 0 and G mod 2 == 0 and B mod 2 == 0: echo 0;return
  var v, w = Seq[int]
  if R mod 2 == 0: # G, B
    for i in N * 2:
      if c[i][0] == 'G': v.add(a[i])
      elif c[i][0] == 'B': w.add(a[i])
  elif G mod 2 == 0: # B, R
    for i in N * 2:
      if c[i][0] == 'B': v.add(a[i])
      elif c[i][0] == 'R': w.add(a[i])
  elif B mod 2 == 0: # R, G
    for i in N * 2:
      if c[i][0] == 'R': v.add(a[i])
      elif c[i][0] == 'G': w.add(a[i])
  return

# input part {{{
block:
  var N = nextInt()
  var a = newSeqWith(2*N, 0)
  var c = newSeqWith(2*N, "")
  for i in 0..<2*N:
    a[i] = nextInt()
    c[i] = nextString()
  solve(N, a, c)
#}}}
