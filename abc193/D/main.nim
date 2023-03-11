include atcoder/extra/header/chaemon_header


const DEBUG = true

proc comb(n, r:int):float =
  if r < 0 or n < r: return 0.0
  result = 1.0
  for i in r:
    result *= n - i
    result /= (i + 1)

proc solve(K:int, S:string, T:string) =
  proc calc_pt(a:seq[int]):int =
    ct := Seq(10, int)
    for a in a: ct[a].inc
    result = 0
    for i in 1..9:
      result += i * 10^ct[i]
  var s, t = newSeq[int]()
  ct := Seq(10,int)
  for c in S:
    if c != '#':
      s.add(c.ord - '0'.ord)
  for c in T:
    if c != '#':
      t.add(c.ord - '0'.ord)
  for a in s: ct[a].inc
  for a in t: ct[a].inc
  ans := 0.0
  for a in 1..9:
    for b in 1..9:
      var s = s
      var t = t
      s.add(a)
      t.add(b)
      let p = calc_pt(s)
      let q = calc_pt(t)
      if p <= q:continue
      var pr = 0.0
      let rest = K * 9 - 8
      if a == b:
        let u = K - ct[a]
        pr =  u * (u - 1)
      else:
        pr = (K - ct[a]) * (K - ct[b])
      pr /= rest * (rest - 1)
      ans += pr
  echo ans
  return

# input part {{{
block:
  var K = nextInt()
  var S = nextString()
  var T = nextString()
  solve(K, S, T)
#}}}

